function fzf-rg-widget --description "Search file contents and insert the selected file path"
    set -l query (commandline --current-token)

    if set -l result (rgf $query)
        commandline -rt -- (string escape --no-quoted -- $result)' '
    end

    commandline -f repaint
end
