function fzf-rg-widget --description "Search file contents and insert the selected file path"
    set -l buffer (commandline)
    set -l trimmed_buffer (string trim -- $buffer)
    set -l current_token (commandline --current-token)
    set -l command (string split -m 1 ' ' -- $trimmed_buffer)[1]
    set -l query $current_token

    if contains -- "$current_token" code nvim
        if test "$trimmed_buffer" = "$current_token"
            set query
        end
    end

    if set -l result (rgf --raw -- $query)
        set -l separator (printf '\t')
        set -l parts (string split -m 3 "$separator" -- $result)
        set -l file $parts[1]
        set -l line $parts[2]
        set -l column $parts[3]

        set -l replacement

        switch "$command"
            case code
                set -l goto_target (string escape --no-quoted -- "$file:$line:$column")
                set replacement "--goto $goto_target"

                if test "$trimmed_buffer" = code; and test "$current_token" = code
                    commandline --replace "code $replacement "
                else
                    commandline -rt -- "$replacement "
                end
            case nvim
                set -l escaped_file (string escape --no-quoted -- $file)
                set replacement "+$line -- $escaped_file"

                if test "$trimmed_buffer" = nvim; and test "$current_token" = nvim
                    commandline --replace "nvim $replacement "
                else
                    commandline -rt -- "$replacement "
                end
            case '*'
                set -l escaped_file (string escape --no-quoted -- $file)
                commandline -rt -- "nvim +$line -- $escaped_file "
        end
    end

    commandline -f repaint
end
