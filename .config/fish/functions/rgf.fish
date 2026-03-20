function rgf --description "Search file contents with ripgrep and return the selected file path"
    if not status is-interactive
        echo "rgf: interactive shell required" >&2
        return 1
    end

    for cmd in rg fzf bat
        if not command -sq $cmd
            echo "rgf: missing required command '$cmd'" >&2
            return 1
        end
    end

    set -l output_mode path
    set -l args $argv

    if test (count $args) -gt 0
        switch $args[1]
            case --raw
                set output_mode raw
                set -e args[1]
            case --
                set -e args[1]
        end
    end

    if test (count $args) -gt 0; and test "$args[1]" = "--"
        set -e args[1]
    end

    set -l separator (printf '\t')
    set -l query (string join ' ' -- $args)
    set -l rg_prefix (string join ' ' -- \
        "rg" \
        "--with-filename" \
        "--column" \
        "--line-number" \
        "--no-heading" \
        "--color=never" \
        "--smart-case" \
        "--hidden" \
        "--glob '!.git'" \
        "--glob '!node_modules'" \
        "--glob '!target'" \
        "--field-match-separator '$separator'" \
        "--field-context-separator '$separator'")
    set -l reload_command "if [ -n {q} ]; then $rg_prefix -- {q} 2>/dev/null; fi || true"
    set -l selection (fzf \
        --disabled \
        --query "$query" \
        --prompt 'rg> ' \
        --delimiter "$separator" \
        --with-nth '1,2,4..' \
        --header 'Enter selects the match' \
        --preview 'bat --style=numbers --color=always --highlight-line {2} -- {1}' \
        --preview-window 'right:70%,border-left,+{2}+3/3,~3' \
        --bind "start:reload:$reload_command" \
        --bind "change:reload:$reload_command")
    or return 1

    if test "$output_mode" = raw
        printf '%s\n' "$selection"
    else
        printf '%s\n' (string split -f 1 "$separator" -- $selection)
    end
end
