set -gx VISUAL nvim
set -gx EDITOR nvim
set -gx MANPAGER "sh -c 'sed -u -e \"s/\\x1B\\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"
