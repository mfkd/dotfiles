#!/bin/sh

# https://github.com/joukewitteveen/xlogin
# Not mentioned on arch wiki but spoken about on github
#if [ -d /etc/X11/xinit/xinitrc.d ]; then
#    for f in /etc/X11/xinit/xinitrc.d/*; do
#        [ -x "$f" ] && . "$f"
#    done
#    unset f
#fi

[ -f "$HOME/.xprofile" ] && . ~/.xprofile

exec dwm
