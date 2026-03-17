function __apply_theme --argument mode
    set -l eza_config_dir
    set -l starship_config
    set -l bat_theme_mode

    switch "$mode"
        case dark
            set eza_config_dir "$HOME/.config/eza/dark"
            set starship_config "$HOME/.config/starship-dark.toml"
            set bat_theme_mode dark
        case light
            set eza_config_dir "$HOME/.config/eza/light"
            set starship_config "$HOME/.config/starship-light.toml"
            set bat_theme_mode light
        case "*"
            echo "__apply_theme: unsupported mode '$mode'" >&2
            return 1
    end

    set -gx EZA_CONFIG_DIR "$eza_config_dir"
    set -gx STARSHIP_CONFIG "$starship_config"
    set -gx BAT_THEME "$bat_theme_mode"

    if set -q FZF_DEFAULT_OPTS_BASE[1]
        __set_fzf_theme "$mode"
    end
end
