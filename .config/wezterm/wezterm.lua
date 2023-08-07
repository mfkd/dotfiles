-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return 'github_dark_default'
  else
    return 'github_light_default'
  end
end

config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())
config.font_size = 14.0
config.hide_tab_bar_if_only_one_tab = true

return config
