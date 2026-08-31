if not status is-interactive
    return
end

if not command -sq fzf
    return
end

set --erase FZF_CTRL_T_COMMAND
set --erase FZF_ALT_C_COMMAND

set --global --unexport FZF_DEFAULT_OPTS_BASE "\
--height=40% \
--layout=reverse \
--border"

set -gx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS_BASE"

set -gx FZF_CTRL_T_OPTS "\
--walker-skip=.git,node_modules,target \
--select-1 \
--exit-0 \
--preview 'if [ -d {} ]; then eza --icons --tree --all --level=2 --color=always {}; else bat -n --color=always --line-range :500 {}; fi' \
--bind 'ctrl-/:change-preview-window(down|hidden|)'"

set -gx FZF_CTRL_R_OPTS "\
--bind 'ctrl-y:execute-silent(printf %s {3..} | pbcopy)+abort' \
--color header:italic"

set -gx FZF_ALT_C_OPTS "\
--walker-skip=.git,node_modules,target \
--select-1 \
--exit-0 \
--preview 'eza --icons --tree --all --level=2 --color=always {}' \
--bind 'ctrl-/:change-preview-window(down|hidden|)'"

set -gx FZF_COMPLETION_OPTS "\
--border \
--info=inline"

fzf --fish | source

bind alt-g 'command rgf; commandline -f repaint'
bind -M insert alt-g 'command rgf; commandline -f repaint'
