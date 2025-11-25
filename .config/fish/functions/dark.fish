function dark
    if test "$fish_theme" != "Catppuccin Mocha"
        echo y | fish_config theme save "Catppuccin Mocha"
        set -Ux fish_theme "Catppuccin Mocha"
    end
end
