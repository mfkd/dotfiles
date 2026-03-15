function __ensure_catppuccin_theme
    string match -q -- "--theme=catppuccin-mocha" "$fish_color_command"
    or fish_config theme choose "catppuccin-mocha" >/dev/null 2>/dev/null
end
