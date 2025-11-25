if status is-interactive
    zoxide init --cmd cd fish | source
    starship init fish | source

    enable_transience

    # Auto-switch theme based on macOS appearance
    set_theme
end
