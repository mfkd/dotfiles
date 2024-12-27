set -U fish_greeting

# Aliases
alias d="docker"
alias k="kubectl"
alias g="git"
alias by="bat -l yaml"

alias ls="eza --icons --group-directories-first"
alias l="eza --icons -l --all --group-directories-first"
alias ll="eza --icons -l --all --all --group-directories-first --git"
alias lt="eza --icons -T --git-ignore --level=2 --group-directories-first"
alias llt="eza --icons -lT --git-ignore --level=2 --group-directories-first"
alias lT="eza --icons -T --git-ignore --level=4 --group-directories-first"
alias tree="eza --icons -T"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

if status is-interactive
    zoxide init fish | source
end
