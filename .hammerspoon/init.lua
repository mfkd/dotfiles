local hyper = { "ctrl", "alt", "cmd", "shift" }

hs.window.animationDuration = 0

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

-- Window management
local function withFocusedWindow(fn)
	local win = hs.window.focusedWindow()

	if win then
		fn(win)
	end
end

local function moveTo(unit)
	return function()
		withFocusedWindow(function(win)
			win:moveToUnit(unit)
		end)
	end
end

-- Halves
hs.hotkey.bind(hyper, "left", moveTo({ x = 0, y = 0, w = 0.5, h = 1 }))
hs.hotkey.bind(hyper, "right", moveTo({ x = 0.5, y = 0, w = 0.5, h = 1 }))
hs.hotkey.bind(hyper, "up", moveTo({ x = 0, y = 0, w = 1, h = 0.5 }))
hs.hotkey.bind(hyper, "down", moveTo({ x = 0, y = 0.5, w = 1, h = 0.5 }))

-- Quarters
hs.hotkey.bind(hyper, "1", moveTo({ x = 0, y = 0, w = 0.5, h = 0.5 }))
hs.hotkey.bind(hyper, "2", moveTo({ x = 0.5, y = 0, w = 0.5, h = 0.5 }))
hs.hotkey.bind(hyper, "3", moveTo({ x = 0, y = 0.5, w = 0.5, h = 0.5 }))
hs.hotkey.bind(hyper, "4", moveTo({ x = 0.5, y = 0.5, w = 0.5, h = 0.5 }))

-- Maximize / center
hs.hotkey.bind(hyper, "return", function()
	withFocusedWindow(function(win)
		win:maximize()
	end)
end)

hs.hotkey.bind(hyper, "space", function()
	withFocusedWindow(function(win)
		win:centerOnScreen(nil, true)
	end)
end)

-- Move between monitors
hs.hotkey.bind(hyper, "[", function()
	withFocusedWindow(function(win)
		win:moveOneScreenWest(false, true)
	end)
end)

hs.hotkey.bind(hyper, "]", function()
	withFocusedWindow(function(win)
		win:moveOneScreenEast(false, true)
	end)
end)

-- Interactive grid
hs.grid.setGrid("6x4")
hs.grid.setMargins({ 8, 8 })
hs.hotkey.bind(hyper, "/", hs.grid.show)

-- Special actions
hs.hotkey.bind(hyper, "\\", hs.reload)

hs.alert.show("Hammerspoon config loaded")
