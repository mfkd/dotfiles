#     _               _              
#    | |__   __ _ ___| |__  _ __ ___ 
#    | '_ \ / _` / __| '_ \| '__/ __|
#    | |_) | (_| \__ \ | | | | | (__ 
#    |_.__/ \__,_|___/_| |_|_|  \___|
#                                    

# https://github.com/joukewitteveen/xlogin
# Not mentioned on arch wiki but spoken about on github
#for sd_cmd in systemctl systemd-analyze systemd-run; do
#    alias $sd_cmd='DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus" '$sd_cmd
#done

# PROMPT
ssh-ps1() {
    printf "%s" "$HOSTNAME "
}

__git_ps1() { :;}
if [ -e ~/.config/git-prompt.sh ]; then
    . ~/.config/git-prompt.sh
fi

nonzero_return() {
    RETVAL=$?
    [ $RETVAL -ne 0 ] && echo "$RETVAL "
}

if [[ $SSH_CONNECTION ]]; then 
    PS1="\[\e[32m\]\`ssh-ps1\`\[\e[m\]\[\e[31m\]\`nonzero_return\`\[\e[m\]\[\e[1;37m\]\w\[\e[m\] \[\e[34m\]\`__git_ps1\`\[\e[m\]\[\e[36m\]$\[\e[m\] "
else
    PS1="\[\e[31m\]\`nonzero_return\`\[\e[m\]\[\e[1;37m\]\w\[\e[m\] \[\e[34m\]\`__git_ps1\`\[\e[m\]\[\e[36m\]$\[\e[m\] "
fi

# SOURCE

[ -e /usr/share/fzf ] && . /usr/share/fzf/completion.bash && . /usr/share/fzf/key-bindings.bash

[ -r /usr/share/z/z.sh ] && . /usr/share/z/z.sh 

[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion

[ -f "$HOME/.config/aliasrc" ] && . "$HOME/.config/aliasrc"

#shopt -s cmdhist autocd dirspell cdspell extglob dotglob globstar expand_aliases direxpand
shopt -s cmdhist autocd direxpand dirspell cdspell extglob globstar 
# HISTORY
shopt -s histappend histverify
PROMPT_DIRTRIM=3
HISTCONTROL=ignoredups:erasedups
HISTSIZE= HISTFILESIZE= 
HISTIGNORE='cd:ls:history:lf:x:xs:l:la:exa:xx:newsboat*:vim:z:neofetch:..:mp:gt:redshift*:calcurse'
HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S:  "
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
#PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$"\n"}history -a; history -c; history -r"

# Disable ctrl-s and ctrl-q.
stty -ixon

#set -o notify
