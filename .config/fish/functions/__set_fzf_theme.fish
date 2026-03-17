function __set_fzf_theme --argument mode
    set -l theme_opts

    switch "$mode"
        case dark
            set theme_opts (string join -- ' ' \
                "--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8" \
                "--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC" \
                "--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8" \
                "--color=selected-bg:#45475A" \
                "--color=border:#6C7086,label:#CDD6F4")
        case light
            set theme_opts (string join -- ' ' \
                "--color=bg+:#CCD0DA,bg:#EFF1F5,spinner:#DC8A78,hl:#D20F39" \
                "--color=fg:#4C4F69,header:#D20F39,info:#8839EF,pointer:#DC8A78" \
                "--color=marker:#7287FD,fg+:#4C4F69,prompt:#8839EF,hl+:#D20F39" \
                "--color=selected-bg:#BCC0CC" \
                "--color=border:#9CA0B0,label:#4C4F69")
        case "*"
            echo "__set_fzf_theme: unsupported mode '$mode'" >&2
            return 1
    end

    set -gx FZF_THEME_OPTS "$theme_opts"

    if set -q FZF_DEFAULT_OPTS_BASE[1]
        set -gx FZF_DEFAULT_OPTS (string join -- ' ' "$FZF_DEFAULT_OPTS_BASE" "$FZF_THEME_OPTS")
    else
        set -gx FZF_DEFAULT_OPTS "$FZF_THEME_OPTS"
    end
end
