if status is-interactive
    if command -q zoxide
        zoxide init --cmd cd fish | source
    end

    __ensure_catppuccin_theme

    function __auto_set_theme --on-variable fish_terminal_color_theme
        set_theme
    end

    set_theme

    if command -q starship
        starship init fish | source
        enable_transience
    end
end
