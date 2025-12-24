function light
    if test "$fish_theme" != "Catppuccin Latte"
        echo y | fish_config theme save "Catppuccin Latte"
        set -Ux fish_theme "Catppuccin Latte"
        starship config palette catppuccin_latte
        set -Ux EZA_CONFIG_DIR ~/.config/eza/light
    end
end
