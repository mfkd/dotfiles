local hyper = {"ctrl", "alt", "cmd", "shift"}

-- Simple app launchers
local apps = {
  C = "Google Chrome",
  S = "Spotify",
  G = "Ghostty",
  O = "Obsidian",
  V = "Visual Studio Code",
  F = "Finder",
  H = "ChatGPT",
  M = "Music",
  I = "Preview",
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