local hyper = { "ctrl", "alt", "cmd", "shift" }

-- Simple app launchers
local apps = {
	A = "Activity Monitor",
	C = "Google Chrome",
	F = "Finder",
	G = "Ghostty",
	H = "ChatGPT",
	I = "Preview",
	L = "Claude",
	M = "Music",
	O = "Obsidian",
	R = "Reminders",
	S = "Spotify",
	V = "Visual Studio Code",
	W = "WhatsApp",
}

local previousAppByKey = {}

local function bindAppLauncher(key, appName)
	hs.hotkey.bind(hyper, key, function()
		local frontmost = hs.application.frontmostApplication()

		if frontmost and frontmost:name() == appName then
			local previous = previousAppByKey[key]

			if previous and previous:isRunning() then
				previous:activate()
			end

			return
		end

		if frontmost then
			previousAppByKey[key] = frontmost
		end

		hs.application.launchOrFocus(appName)
	end)
end

for key, app in pairs(apps) do
	bindAppLauncher(key, app)
end

-- Special actions
hs.hotkey.bind(hyper, "\\", function()
	hs.reload()
end)

hs.alert.show("Hammerspoon config loaded")

