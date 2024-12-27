set -U fish_greeting

if status is-interactive
    zoxide init fish | source
end
