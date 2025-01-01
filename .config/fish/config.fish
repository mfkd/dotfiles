# Suppress the default Fish greeting
set -U fish_greeting

# Environment variables
set -gx VISUAL "nvim"
set -gx EDITOR "nvim"
set --global hydro_symbol_start ""

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

if status is-interactive
    zoxide init fish | source
end
