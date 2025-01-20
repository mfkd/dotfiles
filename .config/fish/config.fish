# Suppress the default Fish greeting
set -U fish_greeting

# Environment variables
set -x VISUAL "nvim"
set -x EDITOR "nvim"
set -x MANPAGER "sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"

# Add directories to PATH only if they exist
set -l paths_to_add \
    $HOME/go/bin \
    $HOME/.cargo/bin \
    $HOME/bin \
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
alias by="bat --language yaml"

alias ls="eza --icons --all --group-directories-first"
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

alias vi="nvim"
alias vim="nvim"

# Functions

function dark
    echo "y" | fish_config theme save "Catppuccin Mocha"
    set -Ux FZF_DEFAULT_OPTS "\
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
    --color=selected-bg:#45475a \
    --multi"
end

function light
    echo "y" | fish_config theme save "Catppuccin Latte"
    set -Ux FZF_DEFAULT_OPTS "\
    --color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39 \
    --color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78 \
    --color=marker:#7287fd,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39 \
    --color=selected-bg:#bcc0cc \
    --multi"
end

function set_theme
    set appearance (defaults read -g AppleInterfaceStyle 2>/dev/null)

    if test "$appearance" = "Dark"
        dark
    else
        light
    end
end

# Set interactive configuration
if status is-interactive
    zoxide init --cmd cd fish | source
end
