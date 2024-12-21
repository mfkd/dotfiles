# ~/.zprofile
# Runs for login shells. Good place to set environment variables.

# Evaluate Homebrew shellenv (this will also set HOMEBREW_PREFIX, PATH, etc.)
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Add user's private bin folder
export PATH="$HOME/bin:$PATH"

# Add Go environment information to PATH (remove if you only want it in interactive shells)
if command -v go &>/dev/null; then
  export PATH="$PATH:$(go env GOPATH)/bin"
fi

# Tool defaults
export EDITOR="code -w"
export VISUAL="code -w"
export PAGER="less"

# (Optional) zsh-syntax-highlighting location (set before sourcing plugin in .zshrc)
# Brew’s shellenv *should* already define HOMEBREW_PREFIX, but just in case:
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR="${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-syntax-highlighting/highlighters"

# less/man colors
export LESS=-R
export LESS_TERMCAP_mb="$(printf '%b' '[1;31m')"
export LESS_TERMCAP_md="$(printf '%b' '[1;36m')"
export LESS_TERMCAP_me="$(printf '%b' '[0m')"
export LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')"
export LESS_TERMCAP_se="$(printf '%b' '[0m')"
export LESS_TERMCAP_us="$(printf '%b' '[1;32m')"
export LESS_TERMCAP_ue="$(printf '%b' '[0m')"