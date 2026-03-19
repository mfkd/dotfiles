function __apply_theme --argument mode
    set -l delta_feature
    set -l bat_theme
    set -l eza_config_dir
    set -l lazygit_config_root "$HOME/.config/lazygit"
    set -l lazygit_base_config "$lazygit_config_root/config.yml"
    set -l lazygit_theme
    set -l starship_config

    if not test -e "$lazygit_base_config"
        set -l apply_theme_file (path resolve (functions -D __apply_theme))
        set -l dotfiles_root (dirname (dirname (dirname (dirname "$apply_theme_file"))))

        set lazygit_config_root "$dotfiles_root/.config/lazygit"
        set lazygit_base_config "$lazygit_config_root/config.yml"
    end

    switch "$mode"
        case dark
            set delta_feature +catppuccin-dark
            set bat_theme "Catppuccin Mocha"
            set eza_config_dir "$HOME/.config/eza/dark"
            set lazygit_theme "$lazygit_config_root/dark/theme.yml"
            set starship_config "$HOME/.config/starship-dark.toml"
        case light
            set delta_feature +catppuccin-light
            set bat_theme "Catppuccin Latte"
            set eza_config_dir "$HOME/.config/eza/light"
            set lazygit_theme "$lazygit_config_root/light/theme.yml"
            set starship_config "$HOME/.config/starship-light.toml"
        case "*"
            echo "__apply_theme: unsupported mode '$mode'" >&2
            return 1
    end

    set -gx DELTA_FEATURES "$delta_feature"
    set -gx BAT_THEME "$bat_theme"
    set -gx EZA_CONFIG_DIR "$eza_config_dir"
    set -gx LG_CONFIG_FILE "$lazygit_base_config,$lazygit_theme"
    set -gx STARSHIP_CONFIG "$starship_config"

    if set -q FZF_DEFAULT_OPTS_BASE[1]
        __set_fzf_theme "$mode"
    end
end
