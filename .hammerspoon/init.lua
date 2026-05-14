local hyper = { "ctrl", "alt", "cmd", "shift" }

-- Simple app launchers
local apps = {
	A = "Activity Monitor",
	C = "Google Chrome",
	F = "Finder",
	G = "Ghostty",
	H = "ChatGPT",
	I = "Preview",
	M = "Music",
	O = "Obsidian",
	S = "Spotify",
	V = "Visual Studio Code",
	W = "WhatsApp",
}

for key, app in pairs(apps) do
	hs.hotkey.bind(hyper, key, function()
		hs.application.launchOrFocus(app)
	end)
end

-- Special actions
hs.hotkey.bind(hyper, "\\", function()
	hs.reload()
end)

hs.alert.show("Hammerspoon config loaded")

