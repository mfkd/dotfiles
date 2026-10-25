local hyper = { "ctrl", "alt", "cmd", "shift" }

-- Simple app launchers
-- Bundle IDs avoid mismatches between launch names and runtime app names,
-- such as "Visual Studio Code.app" reporting itself as "Code".
local apps = {
	[","] = { name = "System Settings", bundleID = "com.apple.systempreferences" },
	A = { name = "Activity Monitor", bundleID = "com.apple.ActivityMonitor" },
	B = { name = "Safari", bundleID = "com.apple.Safari" },
	C = { name = "Google Chrome", bundleID = "com.google.Chrome" },
	E = { name = "Weather", bundleID = "com.apple.weather" },
	F = { name = "Finder", bundleID = "com.apple.finder" },
	G = { name = "Ghostty", bundleID = "com.mitchellh.ghostty" },
	H = { name = "ChatGPT", bundleID = "com.openai.codex" },
	I = { name = "Preview", bundleID = "com.apple.Preview" },
	J = { name = "IINA", bundleID = "com.colliderli.iina" },
	K = { name = "Passwords", bundleID = "com.apple.Passwords" },
	L = { name = "Claude", bundleID = "com.anthropic.claudefordesktop" },
	-- M = { name = "Music", bundleID = "com.apple.Music" },
	M = { name = "Messages", bundleID = "com.apple.MobileSMS" },
	N = { name = "Notes", bundleID = "com.apple.Notes" },
	O = { name = "Obsidian", bundleID = "md.obsidian" },
	P = { name = "Photos", bundleID = "com.apple.Photos" },
	Q = { name = "FaceTime", bundleID = "com.apple.FaceTime" },
	R = { name = "Reminders", bundleID = "com.apple.reminders" },
	S = { name = "Spotify", bundleID = "com.spotify.client" },
	T = { name = "Apple TV", bundleID = "com.apple.TV" },
	U = { name = "Calendar", bundleID = "com.apple.iCal" },
	V = { name = "Visual Studio Code", bundleID = "com.microsoft.VSCode" },
	W = { name = "WhatsApp", bundleID = "net.whatsapp.WhatsApp" },
}

local log = hs.logger.new("config", "warning")
local bindingsOK = true

local function reportFailure(message)
	log.e(message)
	hs.alert.show(message)
end

local function bindHotkey(key, action, callback)
	if not hs.hotkey.bind(hyper, key, callback) then
		bindingsOK = false
		reportFailure("Could not register Hyper+" .. key .. " for " .. action)
	end
end

-- Track focus changes from both hotkeys and manual app switching.
local focusedApp = hs.application.frontmostApplication()
local lastFocusedApp = nil
local previousAppByKey = {}

local function recordActivation(app)
	if not app or not app:isRunning() then
		return
	end

	-- Watcher callbacks can supply a new object for the same process.
	if not focusedApp or focusedApp:pid() ~= app:pid() then
		lastFocusedApp = focusedApp
		focusedApp = app
	end
end

local appWatcher = hs.application.watcher.new(function(_, event, app)
	if event == hs.application.watcher.activated then
		recordActivation(app)
	end
end):start()

-- This closure retains the watcher after init.lua finishes and stops it on reload.
hs.shutdownCallback = function()
	appWatcher:stop()
end

local function canReturnTo(app, targetBundleID)
	return app and app:isRunning() and app:bundleID() ~= targetBundleID
end

local function bindAppLauncher(key, app)
	bindHotkey(key, app.name, function()
		local frontmost = hs.application.frontmostApplication()
		-- Keep history current even if the activation event hasn't arrived yet.
		recordActivation(frontmost)

		if frontmost and frontmost:bundleID() == app.bundleID then
			local previous = previousAppByKey[key]
			if not canReturnTo(previous, app.bundleID) then
				previousAppByKey[key] = nil
				previous = lastFocusedApp
			end

			if not canReturnTo(previous, app.bundleID) then
				reportFailure("No previous app available for " .. app.name)
			elseif not previous:activate() then
				reportFailure("Could not activate " .. (previous:name() or "previous app"))
			end

			return
		end

		-- Save an origin only when the target launches or focuses successfully.
		if hs.application.launchOrFocusByBundleID(app.bundleID) then
			previousAppByKey[key] = frontmost
		else
			reportFailure("Could not launch or focus " .. app.name)
		end
	end)
end

for key, app in pairs(apps) do
	bindAppLauncher(key, app)
end

local function cycleAudioOutput()
	-- Read device details once and skip outputs without an identifier.
	local outputs = {}
	for _, device in ipairs(hs.audiodevice.allOutputDevices()) do
		local uid = device:uid()
		if uid then
			table.insert(outputs, { device = device, uid = uid, name = device:name() or uid })
		end
	end

	if #outputs == 0 then
		hs.alert.show("No audio outputs available")
		return
	end

	-- Sort by name, using the identifier to distinguish duplicate names.
	table.sort(outputs, function(a, b)
		if a.name == b.name then
			return a.uid < b.uid
		end
		return a.name < b.name
	end)

	local currentOutput = hs.audiodevice.defaultOutputDevice()
	local currentUID = currentOutput and currentOutput:uid()
	local nextIndex = 1
	for i, output in ipairs(outputs) do
		if output.uid == currentUID then
			nextIndex = i % #outputs + 1 -- Wrap back to the first output.
			break
		end
	end

	local nextOutput = outputs[nextIndex]
	if nextOutput.device:setDefaultOutputDevice() then
		hs.alert.show("Output: " .. nextOutput.name)
	else
		reportFailure("Could not switch audio output")
	end
end

-- Quit regular Dock apps, leaving background utilities and these apps running.
local quitExclusions = {
	["com.apple.finder"] = true,
	["org.hammerspoon.Hammerspoon"] = true,
}

local function quitAllRegularApps()
	for _, app in ipairs(hs.application.runningApplications()) do
		if app:kind() == 1 and not quitExclusions[app:bundleID()] then
			-- Requests a graceful quit; apps can prompt to save or refuse to quit.
			app:kill()
		end
	end
end

-- Special actions
bindHotkey("D", "audio switching", cycleAudioOutput)
bindHotkey("X", "quitting all regular apps", quitAllRegularApps)
bindHotkey("\\", "config reloading", hs.reload)

if bindingsOK then
	hs.alert.show("Hammerspoon config loaded")
else
	hs.alert.show("Hammerspoon loaded with hotkey errors; see Console")
end
