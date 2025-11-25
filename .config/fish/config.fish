if status is-interactive
    # cat -> bat only in interactive shells
    alias cat="bat --style=plain --paging=never"

    # Optional tools, guarded so they don't error if missing
    type -q zoxide;   and zoxide init --cmd cd fish | source
    type -q starship; and starship init fish | source

    functions -q enable_transience; and enable_transience

    # Auto-switch theme based on macOS appearance
    set_theme
end
