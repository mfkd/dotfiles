function help
    if test (count $argv) -eq 0
        command help
        return
    end

    if type -q $argv[1]
        command $argv --help 2>&1 | bathelp
    else
        echo "Unknown command: $argv[1]" >&2
        return 1
    end
end
