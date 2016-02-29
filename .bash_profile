# ~/.bash_profile: executed by bash for login shells.

# Source global definitions
if [ -f /etc/bashrc ]; then
    # Macintosh (Darwin) and Fedora / Red Hat
    . /etc/bashrc
elif [ -f /etc/bash.bashrc ]; then
    # Raspberry Pi / Debian and Cygwin
    . /etc/bash.bashrc
fi

# source the user's bashrc if it exists
if [ -f "${HOME}/.bashrc" ]; then
    source "${HOME}/.bashrc"
fi

