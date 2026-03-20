if not status is-interactive
    return
end

if not command -sq fzf
    return
end

set -gx FZF_DEFAULT_OPTS_BASE "\
--height=40% \
--layout=reverse \
--border"

set -gx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS_BASE"

set -gx FZF_CTRL_T_COMMAND "command fd --hidden --follow --exclude .git --exclude node_modules --exclude target . \$dir"
set -gx FZF_CTRL_T_OPTS "\
--select-1 \
--exit-0 \
--preview 'if [ -d {} ]; then eza --icons --tree --all --level=2 --color=always {}; else bat -n --color=always --line-range :500 {}; fi' \
--bind 'ctrl-/:change-preview-window(down|hidden|)'"

set -gx FZF_CTRL_R_OPTS "\
--bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' \
--color header:italic \
--header 'Press CTRL-Y to copy command'"

set -gx FZF_ALT_C_COMMAND "command fd --type d --hidden --follow --exclude .git --exclude node_modules --exclude target . \$dir"
set -gx FZF_ALT_C_OPTS "\
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
