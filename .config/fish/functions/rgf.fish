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

    set -l separator (printf '\t')
    set -l query (string join ' ' -- $argv)
    set -l rg_prefix (string join ' ' -- \
        "rg" \
        "--column" \
        "--line-number" \
        "--no-heading" \
        "--color=always" \
        "--smart-case" \
        "--hidden" \
        "--glob '!.git'" \
        "--glob '!node_modules'" \
        "--glob '!target'" \
        "--field-match-separator '$separator'" \
        "--field-context-separator '$separator'")
    set -l reload_command "if [ -n {q} ]; then $rg_prefix -- {q} 2>/dev/null; fi || true"

    fzf \
        --ansi \
        --disabled \
        --query "$query" \
        --prompt 'rg> ' \
        --delimiter "$separator" \
        --with-nth '1,2,4..' \
        --accept-nth 1 \
        --header 'Type to search file contents. Enter returns the file path.' \
        --preview 'bat --style=numbers --color=always --highlight-line {2} -- {1}' \
        --preview-window 'right:70%,border-left,+{2}+3/3,~3' \
        --bind "start:reload:$reload_command" \
        --bind "change:reload:$reload_command"
end
