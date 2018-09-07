# ~/.bash_profile: executed by bash for login shells.

if [ -f "${HOME}/.bashrc" ]; then
    source "${HOME}/.bashrc"
fi
if [[ -n $ITERM_PROFILE && -z $SSH_CLIENT &&
	$(uname -s) == Darwin* && -f "${HOME}/tips.txt" ]]; then
    cat "${HOME}/tips.txt"
fi
