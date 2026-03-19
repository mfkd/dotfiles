# ~/.zshrc
# Runs for interactive shells. Place aliases, prompt, completions, etc. here.

# ------------------------------------------------
# History Configuration
# ------------------------------------------------
HISTFILE=$HOME/.zsh_history         # File where Zsh saves your command history
HISTSIZE=10000000                   # Max number of lines kept in memory
SAVEHIST=10000000                   # Max number of lines saved to $HISTFILE

# Always append history, never overwrite
setopt APPEND_HISTORY               # Append new commands at shell exit
setopt INC_APPEND_HISTORY           # Append to history immediately after each command
setopt SHARE_HISTORY                # Share history across all running Zsh sessions

# Remove duplicates in history
setopt HIST_IGNORE_DUPS             # Ignore a command if it's the same as previous
setopt HIST_IGNORE_ALL_DUPS         # Remove all older occurrences if repeated
setopt HIST_IGNORE_SPACE            # Ignore commands starting with a space
setopt HIST_REDUCE_BLANKS           # Remove extra blank spaces
setopt HIST_EXPIRE_DUPS_FIRST       # Expire older duplicates first when trimming

# ------------------------------------------------
# Zsh Options
# ------------------------------------------------
setopt AUTO_CD                      # cd automatically if command is a directory
setopt COMPLETE_IN_WORD             # Allow completion in the middle of a word
setopt EXTENDED_GLOB                # Enable extended globbing (regex-like patterns)
setopt NO_CLOBBER                   # Prevent overwriting files with '>'
setopt INTERACTIVE_COMMENTS         # Allow # comments in an interactive shell
setopt PROMPT_SUBST                 # Enable prompt substitution (dynamic prompts)

# ------------------------------------------------
# Keybindings
# ------------------------------------------------
bindkey -e                   # Emacs keybindings

# Edit current line in Vim
autoload -U edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# Reverse menu completion if Shift+Tab is supported
if [[ -n "${terminfo[kcbt]}" ]]; then
  bindkey "${terminfo[kcbt]}" reverse-menu-complete
fi

# ------------------------------------------------
# Alias Loading
# ------------------------------------------------
[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"

# ------------------------------------------------
# Completion System
# ------------------------------------------------
autoload -U compinit

# Fuzzy matching configuration (MUST be before compinit)
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'

compinit -i

# ------------------------------------------------
# External Completions (load AFTER compinit)
# ------------------------------------------------
if hash kubectl 2>/dev/null; then
  source <(kubectl completion zsh)
fi

# ------------------------------------------------
# Plugins and Tools
# ------------------------------------------------
# fzf integration
if hash fzf 2>/dev/null; then
  source <(fzf --zsh)
fi

# zoxide for directory navigation
if hash zoxide 2>/dev/null; then
  eval "$(zoxide init --cmd cd zsh)"
fi

# Theme mode and prompt config (dark/light) for starship
typeset -g __current_theme_mode=""

__detect_theme_mode() {
  if command -v defaults >/dev/null 2>&1; then
    if [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]]; then
      print -r -- "dark"
      return 0
    fi
  fi

  print -r -- "light"
}

__apply_theme() {
  local mode="$1"
  local lazygit_config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/lazygit"
  local bat_theme

  typeset -gA ZSH_HIGHLIGHT_STYLES

  case "$mode" in
    dark)
      export DELTA_FEATURES="+catppuccin-dark"
      bat_theme="Catppuccin Mocha"
      export EZA_CONFIG_DIR="$HOME/.config/eza/dark"
      export LG_CONFIG_FILE="$lazygit_config_dir/config.yml,$lazygit_config_dir/dark/theme.yml"
      export STARSHIP_CONFIG="$HOME/.config/starship-dark.toml"
      export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6c7086'
      ZSH_HIGHLIGHT_STYLES[comment]='fg=#6c7086'
      ZSH_HIGHLIGHT_STYLES[command]='fg=#89b4fa'
      ZSH_HIGHLIGHT_STYLES[alias]='fg=#89b4fa'
      ZSH_HIGHLIGHT_STYLES[builtin]='fg=#89dceb'
      ZSH_HIGHLIGHT_STYLES[function]='fg=#89dceb'
      ZSH_HIGHLIGHT_STYLES[path]='fg=#f9e2af'
      ZSH_HIGHLIGHT_STYLES[globbing]='fg=#f5c2e7'
      ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#94e2d5'
      ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#94e2d5'
      ZSH_HIGHLIGHT_STYLES[arg0]='fg=#a6e3a1'
      ZSH_HIGHLIGHT_STYLES[quoted-argument]='fg=#a6e3a1'
      ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#cba6f7'
      ;;
    light)
      export DELTA_FEATURES="+catppuccin-light"
      bat_theme="Catppuccin Latte"
      export EZA_CONFIG_DIR="$HOME/.config/eza/light"
      export LG_CONFIG_FILE="$lazygit_config_dir/config.yml,$lazygit_config_dir/light/theme.yml"
      export STARSHIP_CONFIG="$HOME/.config/starship-light.toml"
      export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#9ca0b0'
      ZSH_HIGHLIGHT_STYLES[comment]='fg=#9ca0b0'
      ZSH_HIGHLIGHT_STYLES[command]='fg=#1e66f5'
      ZSH_HIGHLIGHT_STYLES[alias]='fg=#1e66f5'
      ZSH_HIGHLIGHT_STYLES[builtin]='fg=#179299'
      ZSH_HIGHLIGHT_STYLES[function]='fg=#179299'
      ZSH_HIGHLIGHT_STYLES[path]='fg=#df8e1d'
      ZSH_HIGHLIGHT_STYLES[globbing]='fg=#ea76cb'
      ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#04a5e5'
      ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#04a5e5'
      ZSH_HIGHLIGHT_STYLES[arg0]='fg=#40a02b'
      ZSH_HIGHLIGHT_STYLES[quoted-argument]='fg=#40a02b'
      ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#8839ef'
      ;;
    *)
      return 1
      ;;
  esac

  export BAT_THEME="$bat_theme"
}

set_theme() {
  local mode
  mode="$(__detect_theme_mode)"

  if [[ "$__current_theme_mode" == "$mode" ]]; then
    return 0
  fi

  if __apply_theme "$mode"; then
    __current_theme_mode="$mode"
  fi
}

autoload -Uz add-zsh-hook
set_theme

# zsh-autosuggestions
if [[ -f "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# zsh-syntax-highlighting
if [[ -f "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# starship prompt
if hash starship 2>/dev/null; then
  eval "$(starship init zsh)"
fi

[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
