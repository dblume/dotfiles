# ~/.bash_profile: executed by bash for login shells.

if [ -f "${HOME}/.bashrc" ]; then
    source "${HOME}/.bashrc"
fi
if [[ $(uname -s) == Darwin* && -z $SSH_CLIENT && 
	-n $ITERM_PROFILE && -f "${HOME}/tips.txt" ]]; then
    cat ~/tips.txt
fi
