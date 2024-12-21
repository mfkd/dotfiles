# ~/.zshrc
# Runs for interactive shells. Place aliases, prompt, completions, etc. here.

# ------------------------------------------
# Powerlevel10k Instant Prompt (keep on top)
# ------------------------------------------
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ------------------------------------------------
# History Configuration
# ------------------------------------------------
HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/history"
HISTSIZE=50000
SAVEHIST=50000

setopt share_history            # Share history between all sessions
setopt append_history           # Append history rather than overwrite
setopt inc_append_history_share # Sync history in real-time
setopt hist_ignore_dups         # Ignore duplicates
setopt hist_ignore_space        # Ignore commands starting with space
setopt hist_reduce_blanks       # Remove extra blanks
setopt hist_expire_dups_first   # Remove older duplicates first

# ------------------------------------------------
# Zsh Options
# ------------------------------------------------
setopt autocd                 # cd automatically if input is a directory
setopt complete_in_word       # Allow completion in the middle of words
setopt extendedglob           # Enable extended globbing
setopt noclobber              # Prevent overwriting files with '>'
setopt interactivecomments    # Allow comments in interactive shell
setopt prompt_subst           # Enable prompt substitution

# ------------------------------------------------
# Keybindings
# ------------------------------------------------
bindkey -e

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
# External Completions (load BEFORE compinit)
# ------------------------------------------------
if hash kubectl 2>/dev/null; then
  source <(kubectl completion zsh)
fi

# (Add any other external completions here, e.g. helm, gh, etc.)

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
# Plugins and Tools
# ------------------------------------------------
# fzf integration
if hash fzf 2>/dev/null; then
  source <(fzf --zsh)
fi

# zoxide for directory navigation
if hash zoxide 2>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# zsh-autosuggestions (AFTER compinit)
if [[ -f "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# zsh-syntax-highlighting (AFTER compinit)
if [[ -f "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# ------------------------------------------------
# Powerlevel10k Configuration
# ------------------------------------------------
if [[ -f "${HOMEBREW_PREFIX}/share/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  source "${HOMEBREW_PREFIX}/share/powerlevel10k/powerlevel10k.zsh-theme"
fi

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh