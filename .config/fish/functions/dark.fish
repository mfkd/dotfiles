function dark
    if test "$fish_theme" != "Catppuccin Mocha"
        echo y | fish_config theme save "Catppuccin Mocha"
        set -Ux fish_theme "Catppuccin Mocha"
        starship config palette catppuccin_mocha
        set -Ux EZA_CONFIG_DIR ~/.config/eza/dark
    end
end
