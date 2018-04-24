if [[ $(uname -s) != Darwin* ]] && [ -f /etc/bashrc ]; then
    # Fedora but not Macintosh requires explicit sourcing of /etc/bashrc
    # On Debian, it's /etc/bash.bashrc, but it doesn't have to be sourced here.
    . /etc/bashrc
fi

export PROMPT_DIRTRIM=3
if [[ -n $SSH_CLIENT ]]; then
    export PS1='$(if [ $? -eq 0 ]; then echo -e "\[\e[32m\]\xe2\x9c\x93"; else echo -e "\[\e[31m\]\xe2\x9c\x97"; fi) \[\e[38;5;242m\]\h:\w$\[\e[0m\] '
else
    export PS1='$(if [ $? -eq 0 ]; then echo -e "\[\e[32m\]\xe2\x9c\x93"; else echo -e "\[\e[31m\]\xe2\x9c\x97"; fi) \[\e[38;5;242m\]\w$\[\e[0m\] '
fi

set -o vi

add_to_path() {
    if [ -d "$1" ] && [[ ! $PATH =~ (^|:)$1(:|$) ]]; then
        PATH+=:$1
    fi
}

# if this is a CygWin .bashrc, then set CygWin's commands first in PATH
# because link.exe and find.exe exist in Windows's path.
# Add /usr/lib/lapack at the end so python's numpy can find lapack_lite
# (Note: BSD bash, used by OS X doesn't have the "substr" test for expr.)
if [[ $(uname -s) == CYGWIN* ]]; then
    PATH=/usr/local/bin:/usr/bin:$PATH
    PATH=${PATH//":/usr/local/bin:/usr/bin"/} # delete any instances in middle
    add_to_path /usr/lib/lapack
    ulimit -n 1024 # for "duplicity"
fi

# change the color of directories in the ls command 
if [[ $(uname -s) == Darwin* ]]; then
    export LSCOLORS=gxfxcxdxbxegedabagacad
    export CLICOLOR=1
else
    # After executing: dircolors -p > .dircolors
    # Lighten the color of directories from blue to light blue
    # sed -i '/# directory/c\DIR 00;36 # directory' .dircolors
    if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto'
    fi
fi

export P4DIFF='vim -d'  # Override from the command line: "P4DIFF=; p4 diff main.py"
export CSCOPE_EDITOR=vim

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add to PATH only if not already in PATH.
add_to_path $HOME/bin

alias findinpyfiles="find . -name \*.py -print0 | xargs -0 grep -nI"
alias findinchppfiles="find . -type f \( -name \*.[ch]pp -or -name \*.[ch] \) -print0 | xargs -0 grep -nI"
alias findincppfiles="find . -type f \( -name \*.cpp -or -name \*.c \) -print0 | xargs -0 grep -nI"
alias findinhppfiles="find . -type f \( -name \*.hpp -or -name \*.h \) -print0 | xargs -0 grep -nI"

alias clip="expand | cut -b1-\$COLUMNS"

# For httpie: https://github.com/jakubroztocil/httpie#installation
alias https='http --default-scheme=https'

if [ -f $HOME/.localrc ]; then
    source $HOME/.localrc
fi
