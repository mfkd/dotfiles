local hyper = { "ctrl", "alt", "cmd", "shift" }

-- Simple app launchers
-- Bundle IDs avoid mismatches between launch names and runtime app names,
-- such as "Visual Studio Code.app" reporting itself as "Code".
local apps = {
	A = { name = "Activity Monitor", bundleID = "com.apple.ActivityMonitor" },
	C = { name = "Google Chrome", bundleID = "com.google.Chrome" },
	F = { name = "Finder", bundleID = "com.apple.finder" },
	G = { name = "Ghostty", bundleID = "com.mitchellh.ghostty" },
	H = { name = "ChatGPT", bundleID = "com.openai.codex" },
	I = { name = "Preview", bundleID = "com.apple.Preview" },
	L = { name = "Claude", bundleID = "com.anthropic.claudefordesktop" },
	-- M = { name = "Music", bundleID = "com.apple.Music" },
	M = { name = "Messages", bundleID = "com.apple.MobileSMS" },
	N = { name = "Notes", bundleID = "com.apple.Notes" },
	O = { name = "Obsidian", bundleID = "md.obsidian" },
	P = { name = "Photos", bundleID = "com.apple.Photos" },
	R = { name = "Reminders", bundleID = "com.apple.reminders" },
	S = { name = "Spotify", bundleID = "com.spotify.client" },
	V = { name = "Visual Studio Code", bundleID = "com.microsoft.VSCode" },
	W = { name = "WhatsApp", bundleID = "net.whatsapp.WhatsApp" },
}

-- Tracks the last focused app before any hotkey fired, used as a fallback
-- when previousAppByKey[key] is nil (i.e. the target app was opened manually,
-- not via a hotkey).
local lastApp = nil
local previousAppByKey = {}

local function bindAppLauncher(key, app)
	hs.hotkey.bind(hyper, key, function()
		local frontmost = hs.application.frontmostApplication()

		if frontmost and frontmost:bundleID() == app.bundleID then
			local previous = previousAppByKey[key] or lastApp

			if previous and previous:isRunning() then
				previous:activate()
			end

			return
		end

		if frontmost then
			lastApp = frontmost
			previousAppByKey[key] = frontmost
		end

		hs.application.launchOrFocusByBundleID(app.bundleID)
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
		hs.alert.show("Could not switch audio output")
	end
end

-- Special actions
if not hs.hotkey.bind(hyper, "D", cycleAudioOutput) then
	hs.alert.show("Could not register Hyper+D for audio switching")
end
hs.hotkey.bind(hyper, "\\", hs.reload)

hs.alert.show("Hammerspoon config loaded")
