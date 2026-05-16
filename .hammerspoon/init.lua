local hyper = { "ctrl", "alt", "cmd", "shift" }

-- Simple app launchers
-- Bundle IDs avoid mismatches between launch names and runtime app names,
-- such as "Visual Studio Code.app" reporting itself as "Code".
local apps = {
	A = { name = "Activity Monitor", bundleID = "com.apple.ActivityMonitor" },
	C = { name = "Google Chrome", bundleID = "com.google.Chrome" },
	F = { name = "Finder", bundleID = "com.apple.finder" },
	G = { name = "Ghostty", bundleID = "com.mitchellh.ghostty" },
	H = { name = "ChatGPT", bundleID = "com.openai.chat" },
	I = { name = "Preview", bundleID = "com.apple.Preview" },
	L = { name = "Claude", bundleID = "com.anthropic.claudefordesktop" },
	M = { name = "Music", bundleID = "com.apple.Music" },
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

local function areStartupModifiersReleased()
	local modifiers = hs.eventtap.checkKeyboardModifiers()

	return not modifiers.ctrl and not modifiers.alt and not modifiers.cmd and not modifiers.shift
end

local function afterStartupModifiersReleased(fn)
	if areStartupModifiersReleased() then
		fn()
		return
	end

	local timer = nil
	timer = hs.timer.doEvery(0.02, function()
		if areStartupModifiersReleased() then
			timer:stop()
			fn()
		end
	end)
end

local function bindAppLauncher(key, app)
	local function launchOrToggleApp()
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
	end

	-- Delay app launch/focus until startup modifiers are released so apps do
	-- not see held Shift/Option/Command/Control during launch.
	hs.hotkey.bind(hyper, key, function() end, function()
		afterStartupModifiersReleased(launchOrToggleApp)
	end)
end

for key, app in pairs(apps) do
	bindAppLauncher(key, app)
end

-- Special actions
hs.hotkey.bind(hyper, "\\", hs.reload)

hs.alert.show("Hammerspoon config loaded")
