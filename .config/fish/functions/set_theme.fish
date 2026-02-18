function set_theme
    set -l mode

    switch "$fish_terminal_color_theme"
        case dark light
            set mode "$fish_terminal_color_theme"
        case "*"
            # If Fish cannot determine terminal color theme yet, keep current.
            if set -q __current_theme_mode[1]
                return
            end
            set mode dark
    end

    if test "$__current_theme_mode" = "$mode"
        return
    end

    if __apply_theme "$mode"
        set -g __current_theme_mode "$mode"
    end
end
