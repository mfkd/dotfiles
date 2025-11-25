if not set -q MY_ABBR_SET
    set -U MY_ABBR_SET true

    abbr -a c  codex
    abbr -a g  git
    abbr -a k  kubectl
    abbr -a d  docker
    abbr -a vi nvim
    abbr -a vim nvim
end
