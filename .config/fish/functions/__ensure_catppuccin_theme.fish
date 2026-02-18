function __ensure_catppuccin_theme
    if test "$fish_theme" != "Catppuccin Mocha"
        fish_config theme choose "Catppuccin Mocha" >/dev/null 2>/dev/null
    end
end
