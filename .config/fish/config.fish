# Suppress the default Fish greeting
set -U fish_greeting

# Environment variables
set -gx VISUAL "code --wait"
set -gx EDITOR "code --wait"

# Add directories to PATH only if they exist
set -l paths_to_add \
    $HOME/go/bin \
    $HOME/.cargo/bin \
    $HOME/bin \
    /Library/Frameworks/Python.framework/Versions/3.12/bin \
    /opt/homebrew/bin \
    /opt/homebrew/sbin

for path in $paths_to_add
    if test -d $path
        fish_add_path $path
    end
end

# Aliases
alias d="docker"
alias k="kubectl"
alias g="git"
alias by="bat -l yaml"

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

if status is-interactive
    zoxide init fish | source
end
