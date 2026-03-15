if status is-interactive
    zoxide init --cmd cd fish | source

    __ensure_catppuccin_theme

    function __auto_set_theme --on-variable fish_terminal_color_theme
        set_theme
    end

    set_theme

    starship init fish | source
    enable_transience
end
