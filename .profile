export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

. "$HOME/.cargo/env"

. "$HOME/.local/bin/env"

[ -f "$HOME/.profile.local" ] && . "$HOME/.profile.local"
