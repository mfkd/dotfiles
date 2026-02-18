function __ensure_catppuccin_theme
    # Use Fish built-in catppuccin-mocha only; Fish auto-switches its light/dark variants.
    if test "$fish_theme" != "catppuccin-mocha"
        fish_config theme choose "catppuccin-mocha" >/dev/null 2>/dev/null
    end
end
