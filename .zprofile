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

# Less colors

# Reset and colors
normal=$(tput sgr0)
bold=$(tput bold)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)

# Headers and commands
export LESS_TERMCAP_mb="$normal"              # Blink (not commonly used)
export LESS_TERMCAP_md="${bold}${blue}"       # Bold blue for headers
export LESS_TERMCAP_me="$normal"              # Reset styles

# Status bar
export LESS_TERMCAP_so="${bold}${yellow}"     # Bold yellow for status bar
export LESS_TERMCAP_se="$normal"              # Reset status bar

# Arguments
export LESS_TERMCAP_us="${bold}${green}"      # Bold green underline
export LESS_TERMCAP_ue="$normal"              # Reset underline