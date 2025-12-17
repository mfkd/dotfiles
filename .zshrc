# ~/.zshrc
# Runs for interactive shells. Place aliases, prompt, completions, etc. here.

# ------------------------------------------
# Powerlevel10k Instant Prompt (keep on top)
# ------------------------------------------
# Initialization code requiring console input (password prompts, [y/n] prompts, etc.)
# must go above this block; everything else can go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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

# zsh-autosuggestions
if [[ -f "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# zsh-syntax-highlighting
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