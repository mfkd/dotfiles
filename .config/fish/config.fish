# Suppress the default Fish greeting
set -U fish_greeting

# Environment variables
set -gx VISUAL "nvim"
set -gx EDITOR "nvim"
# set --global hydro_symbol_start "nix "
set --global hydro_symbol_prompt " "

# Aliases
alias d="docker"
alias k="kubectl"
alias g="git"
alias by="bat --language yaml"

alias ls="eza --icons --oneline --group-directories-first"
alias l="eza --icons --long --all --group-directories-first"
alias ll="eza --icons --long --all --all --group-directories-first --git"
alias lt="eza --icons --tree --git-ignore --level=2 --group-directories-first"
alias llt="eza --icons --long --tree --git-ignore --level=2 --group-directories-first"
alias lT="eza --icons --tree --git-ignore --level=4 --group-directories-first"
alias tree="eza --icons --tree"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Functions
# Hack to make fish work with command-not-found on nix
function fish_command_not_found
    set helper_path '/nix/store/wkpb86299p5p1nmqdk6c1mbffcphzs6w-command-not-found/bin/command-not-found'
    set sqlite_path '/nix/var/nix/profiles/per-user/root/channels/nixos/programs.sqlite'

    if test -x $helper_path -a -f $sqlite_path
        # Run the helper program
        $helper_path $argv

        # Check if the command was installed and needs re-execution
        if test $status -eq 126
            eval $argv
        else
            return 127
        end
    else
        echo "$argv[1]: command not found" >&2
        return 127
    end
end

if status is-interactive
    zoxide init fish | source
end
