# ~/.bash_profile: executed by bash for login shells.

if [ -f "${HOME}/.bashrc" ]; then
    source "${HOME}/.bashrc"
fi
if [[ -n $ITERM_PROFILE && -z $SSH_CLIENT &&
    $(uname -s) == Darwin* && -f "${HOME}/tips.txt" ]]; then
    cat "${HOME}/tips.txt"
fi
# https://unix.stackexchange.com/questions/1288/preserve-bash-history-in-multiple-terminal-windows
HISTCONTROL=ignoredups:erasedups
shopt -s histappend
