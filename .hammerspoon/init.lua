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
	O = { name = "Obsidian", bundleID = "md.obsidian" },
	P = { name = "Photos", bundleID = "com.apple.Photos" },
	R = { name = "Reminders", bundleID = "com.apple.reminders" },
	S = { name = "Spotify", bundleID = "com.spotify.client" },
	V = { name = "Visual Studio Code", bundleID = "com.microsoft.VSCode" },
	W = { name = "WhatsApp", bundleID = "net.whatsapp.WhatsApp" },
}

local previousAppByKey = {}

local function bindAppLauncher(key, app)
	hs.hotkey.bind(hyper, key, function()
		local frontmost = hs.application.frontmostApplication()

		if frontmost and frontmost:bundleID() == app.bundleID then
			local previous = previousAppByKey[key]

			if previous and previous:isRunning() then
				previous:activate()
			end

			return
		end

		if frontmost then
			previousAppByKey[key] = frontmost
		end

		hs.application.launchOrFocusByBundleID(app.bundleID)
	end)
end

for key, app in pairs(apps) do
	bindAppLauncher(key, app)
end

-- Special actions
hs.hotkey.bind(hyper, "\\", hs.reload)

hs.alert.show("Hammerspoon config loaded")

