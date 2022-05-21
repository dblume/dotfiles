# ~/.bash_profile: executed by bash for login shells.

if [ -f "${HOME}/.bashrc" ]; then
    source "${HOME}/.bashrc"
fi
if [[ $(uname -s) == Darwin* ]]; then
    if [[ -n $ITERM_PROFILE && -z $SSH_CLIENT && -f "${HOME}/tips.txt" ]]; then
        cat "${HOME}/tips.txt"
    fi
    if [[ -f $(brew --prefix)/etc/bash_completion ]]; then
        source $(brew --prefix)/etc/bash_completion
    fi
fi
