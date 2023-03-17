#!/bin/zsh

# Add go environment information to path
export PATH=$PATH:$(go env GOPATH)/bin

# Emacs mode
bindkey -e

#history
HISTFILE=$HOME/.zsh_history
HISTSIZE=50000
SAVEHIST=$HISTSIZE

setopt append_history
setopt hist_ignore_space

# options
set -o autocd
set -o always_to_end
set -o append_history
set -o complete_in_word
set -o extendedglob
set -o histappend
set -o histignorealldups
set -o histignorespace
set -o interactivecomments
set -o ksh_glob
set -o no_bang_hist
set -o no_bare_glob_qual
set -o no_extended_glob
set -o noclobber
set -o nullglob
set -o prompt_subst
set -o rmstarsilent
set -o shwordsplit
#set -o correctall

# completion
autoload -U compinit
compinit -i

LISTMAX=0

# zsh's git tab completion by default is extremely slow. This makes it use
# local files only. See http://stackoverflow.com/a/9810485/945780.
__git_files () {
    _wanted files expl 'local files' _files
}

# "git" is a wrapper for git-variable-author, inherit its completions.
compdef git-variable-author=git

#compdef sshrc=ssh

# Fuzzy matching
# 0 -- vanilla completion (abc => abc)
# 1 -- smart case completion (abc => Abc)
# 2 -- word flex completion (abc => A-big-Car)
# 3 -- full flex completion (abc => ABraCadabra)
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'

# ---------------------------------------------------------------------------------------------------
# .
# ---------------------------------------------------------------------------------------------------

[ -e "$HOME/.config/fzf" ] && . "$HOME/.config/fzf/completion.zsh" && . "$HOME/.config/fzf/key-bindings.zsh"
[ -f "$HOME/.config/aliasrc" ] && . "$HOME/.config/aliasrc"

# ---------------------------------------------------------------------------------------------------

# Edit line in vim
autoload -U edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line
bindkey '^xe' edit-command-line

#keybindings
if [[ "${terminfo[kcbt]}" != "" ]]; then
  bindkey "${terminfo[kcbt]}" reverse-menu-complete   # [Shift-Tab] - move through the completion menu backwards
fi

#colors / completion
zstyle ':completion:*:default' list-colors "${(s.:.)LS_COLORS}"

HOMEBREW_PREFIX=/opt/homebrew
if [[ -f ${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source ${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
