export PS1="\W\$ "

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
    alias ls='ls --color=auto'
elif [[ $(uname -s) == Darwin* ]]; then
    export LSCOLORS=gxfxcxdxbxegedabagacad
    export CLICOLOR=1
fi

# change the color of directories in the ls command 
#
# After executing: dircolors -p > .dircolors
# And changing the following line in .dircolors:
# DIR 00;36 # directory
if [ "$TERM" != "dumb" ]; then
    [ -e "$HOME/.dircolors" ] && DIR_COLORS="$HOME/.dircolors"
    [ -e "$DIR_COLORS" ] || DIR_COLORS=""
    eval "`dircolors -b $DIR_COLORS`"
fi

# Add to PATH only if not already in PATH.
add_to_path $HOME/bin

alias findinchppfiles="find . -type f \( -name \*.[ch]pp -or -name \*.[ch] \) -print0 | xargs -0 grep -nI"
alias findinpyfiles="find . -name \*.py -print0 | xargs -0 grep -nI"
