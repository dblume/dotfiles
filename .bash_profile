# ~/.bash_profile: executed by bash for login shells.

if [ -f "${HOME}/.bashrc" ]; then
    source "${HOME}/.bashrc"
fi
if [[ $(uname -s) == Darwin* ]]; then
    if [[ -n $ITERM_PROFILE && -z $SSH_CLIENT && -f "${HOME}/tips.txt" ]]; then
        cat "${HOME}/tips.txt"
    fi
    if [[ -n $CDPATH && -f $(brew --prefix)/etc/bash_completion ]]; then
        # brew install bash-completion (for $CDPATH completion)
        source $(brew --prefix)/etc/bash_completion
    fi
    if [[ -f $(brew --prefix)/bin/ctags ]]; then
        alias ctags="$(brew --prefix)/bin/ctags"
    fi
    # Set default names for GNU grep, sed and find
    PATH="/usr/local/opt/grep/libexec/gnubin:/usr/local/opt/gnu-sed/libexec/gnubin:/usr/local/opt/findutils/libexec/gnubin:$PATH"
fi
