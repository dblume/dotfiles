# ~/.bash_profile: executed by bash for login shells.

if [ -f "${HOME}/.bashrc" ]; then
    if [[ $(uname -s) == Darwin* ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
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
    if [[ -d "/usr/local/opt/grep/libexec/gnubin" ]]; then  # old path
        prepend_to_path /usr/local/opt/grep/libexec/gnubin
    elif [[ -d "/opt/homebrew/opt/grep/libexec/gnubin" ]]; then
        prepend_to_path /opt/homebrew/opt/grep/libexec/gnubin
    fi
    if [[ -d "/usr/local/opt/gnu-sed/libexec/gnubin" ]]; then  # old path
        prepend_to_path /usr/local/opt/gnu-sed/libexec/gnubin
    elif [[ -d "/opt/homebrew/opt/gnu-sed/libexec/gnubin" ]]; then
        prepend_to_path /opt/homebrew/opt/gnu-sed/libexec/gnubin
    fi
    if [[ -d "/usr/local/opt/findutils/libexec/gnubin" ]]; then  # old path
        prepend_to_path /usr/local/opt/findutils/libexec/gnubin
    elif [[ -d "/opt/homebrew/opt/findutils/libexec/gnubin" ]]; then
        prepend_to_path /opt/homebrew/opt/findutils/libexec/gnubin
    fi
fi
