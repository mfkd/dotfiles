if status is-interactive
    zoxide init --cmd cd fish | source

    function __auto_set_theme --on-variable fish_terminal_color_theme
        set_theme
    end

    __ensure_catppuccin_theme
    set_theme

    starship init fish | source
    enable_transience
end
