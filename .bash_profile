# ~/.bash_profile: executed by bash for login shells.

if [ -f "${HOME}/.bashrc" ]; then
    if [[ $(uname -s) == Darwin* ]]; then
        # Mac M1 installs into /opt/homebrew/; Intel Mac installs into /usr/local/
        if [ -d "/opt/homebrew/bin/" ] && [[ ! $PATH =~ (^|:)/opt/homebrew/bin/(:|$) ]]; then
            PATH+=:/opt/homebrew/bin/
        fi
        command -v brew >/dev/null 2>&1 && eval "$(brew shellenv)"
    fi
    source "${HOME}/.bashrc"
fi
if [[ $(uname -s) == Darwin* ]]; then
    if [[ -z $SSH_CLIENT && -f "${HOME}/tips.txt" ]]; then
        cat "${HOME}/tips.txt"
    fi
    if [[ -n $CDPATH && -f $HOMEBREW_PREFIX/etc/bash_completion ]]; then
        # brew install bash-completion (for $CDPATH completion)
        source $HOMEBREW_PREFIX/etc/bash_completion
    fi
    if [[ -f $HOMEBREW_PREFIX/bin/ctags ]]; then
        alias ctags="$HOMEBREW_PREFIX/bin/ctags"
    fi
    # Set default names for GNU grep, sed and find
    prepend_to_path $HOMEBREW_PREFIX/opt/grep/libexec/gnubin
    prepend_to_path $HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin
    prepend_to_path $HOMEBREW_PREFIX/opt/findutils/libexec/gnubin
    prepend_to_path $HOMEBREW_PREFIX/opt/gawk/libexec/gnubin
fi
