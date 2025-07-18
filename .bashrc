if [[ $(uname -s) != Darwin* ]] && [ -f /etc/bashrc ]; then
    # Fedora but not Macintosh requires explicit sourcing of /etc/bashrc
    # On Debian, it's /etc/bash.bashrc, but it doesn't have to be sourced here.
    . /etc/bashrc
fi

if [[ -v PS1 ]] && ! $(declare -F __git_ps1 >/dev/null); then
    # Try to source a file with __git_ps1
    if [[ -e /usr/lib/git-core/git-sh-prompt ]]; then
        . /usr/lib/git-core/git-sh-prompt
    elif [[ -e /usr/share/git-core/contrib/completion/git-prompt.sh ]]; then
        . /usr/share/git-core/contrib/completion/git-prompt.sh
    elif [[ $(uname -s) == Darwin* ]] && [[ -f $(brew --prefix git)/etc/bash_completion.d/git-prompt.sh ]]; then
        . $(brew --prefix git)/etc/bash_completion.d/git-prompt.sh
    elif [[ -f $HOME/.git-prompt.sh ]]; then
        # wget -O ~/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
        . $HOME/.git-prompt.sh
    fi

    # Still no __git_ps1? Fake it.
    if ! $(declare -F __git_ps1 >/dev/null); then
        # By icetan at https://stackoverflow.com/a/35513635/9181
        # Ex. to test if in a git repo: "rtrav .git $PWD"
        rtrav() { [ -e "$2"/"$1" ] || { [ "$2" != / ] && rtrav "$1" $(dirname "$2"); } }

        __git_ps1() {
            if rtrav .git "$PWD"; then
                local fmt="${1:- (%s)}"
                local branch=$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
                if [ -n "$branch" ]; then
                    printf -- "$fmt" "$branch"
                fi
            fi
        }
    fi
fi

GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_SHOWDIRTYSTATE="true"
GIT_PS1_STATESEPARATOR=""

# Trim everything before the dash, then trim everything after the colon.
PS1_DOCKER_VER=${DOCKER_VER#*-}
PS1_DOCKER_VER="🐳 \e[0;36m${PS1_DOCKER_VER%:*}"

# In PS1, "\h" is hostname
if [[ -n $SSH_CLIENT ]]; then
    PS1_HOSTNAME="$HOSTNAME:"
else
    PS1_HOSTNAME=
fi

export PROMPT_DIRTRIM=2
export PS1='$(if [ $? -eq 0 ]; then echo -e "\[\e[32m\]\xe2\x9c\x93";
              else echo -e "\[\e[31m\]\xe2\x9c\x97";
              fi)$(if [ -n "$DOCKER_VER" ]; then echo -e " $PS1_DOCKER_VER";
              fi) \[\e[38;5;242m\]$PS1_HOSTNAME\w$(__git_ps1 " \[\e[38;5;030m\]%s\[\e[38;5;242m\]")$\[\e[0m\] '

set -o vi

append_to_path() {
    if [ -d "$1" ] && [[ ! $PATH =~ (^|:)$1(:|$) ]]; then
        PATH+=:$1
    fi
}

prepend_to_path() {
    if [ -d "$1" ] && [[ ! $PATH =~ (^|:)$1(:|$) ]]; then
        PATH=$1:$PATH
    fi
}

remove_from_path() {
    # N.B. It'll remove all instances of $1, so ensure it's a unique pathname
    PATH=${PATH//"$1"/}
}

# if this is a CygWin .bashrc, then set CygWin's commands first in PATH
# because link.exe and find.exe exist in Windows's path.
# Add /usr/lib/lapack at the end so python's numpy can find lapack_lite
# (Note: BSD bash, used by OS X doesn't have the "substr" test for expr.)
if [[ $(uname -s) == CYGWIN* ]]; then
    prepend_to_path /usr/bin
    prepend_to_path /usr/local/bin
    remove_from_path ":/usr/local/bin:/usr/bin"
    append_to_path /usr/lib/lapack
    export GIT_SSH=/cygdrive/c/cygwin64/bin/ssh
    ulimit -n 1024 # for "duplicity"
elif [[ -n "${WSL_DISTRO_NAME}" ]]; then
    export BROWSER=/mnt/c/Program\ Files\ \(x86\)/Google/Chrome/Application/chrome.exe
    alias pbcopy='tee <&0 | /mnt/c/Windows/System32/clip.exe'
    alias tail='tail ---disable-inotify'
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
export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc

alias grep='grep --color=auto --exclude-dir=.git'
alias fgrep='fgrep --color=auto --exclude-dir=.git'
alias egrep='egrep --color=auto --exclude-dir=.git'
alias tmux='tmux -2u'

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# .local/bin must come before /usr/bin and /bin for VisiData and clang-format
remove_from_path $HOME/.local/bin
prepend_to_path $HOME/.local/bin
# Add to PATH only if not already in PATH.
append_to_path $HOME/bin
# .cargo/bin for rustc
append_to_path $HOME/.cargo/bin

if command -v nvim &> /dev/null; then
    alias vim='nvim'
    alias vim-='nvim +"setl buftype=nofile" -'
    alias vimdiff='nvim -d'
else
    alias vim-='vim +"setl buftype=nofile" -'
fi

# For interactive shells ('i' in $-), disable stty flow control (ctrl+s,ctrl+q)
case "$-" in
 *i*)
  stty start ''
  stty stop  ''
  stty -ixon # disable XON/XOFF flow control
  stty ixoff # enable sending (to app) of start/stop characters
  stty ixany # let any character restart output, not only start character

  if [ -f ${HOME}/bin/set_colorscheme ]; then
    source ${HOME}/bin/set_colorscheme
  fi

  # Don't use export for CDPATH. This may get appended to in .localrc too.
  # You may have to explicitly source /usr/share/bash-completion/bash_completion
  CDPATH=.:$HOME

  # gnome-terminal can't distinguish C-i vs Tab, have i3wm use alacritty
  export TERMINAL=alacritty

  # This sets the terminal title
  PROMPT_COMMAND="echo -ne \"\033]0;$HOSTNAME\007\""

  # Enables recursive matches: ls -l **/*.png
  shopt -s globstar
 ;;
esac

# Keeping as an example, but haven't used since ripgrep
#alias findinchppfiles="find . -type f \( -name \*.[ch]pp -or -name \*.[ch] \) -print0 | xargs -0 grep -nI"

alias clip="expand | cut -b1-\$COLUMNS"

# I'm often interested in just the most recently changed file
# N.B. If changing -l to -1, remove tail, because "total" line is only for -l
lh() {
    if [[ $(uname -s) != Darwin* ]]; then
        local -r color_always="--color=always"
    fi
    ls $color_always -ltqh "$@" | head -$(($LINES/4)) | tail -n +2
    if [ $(ls -1 "$@" | wc -l) -gt $(($LINES/4)) ]; then
        echo ...
    fi
}

# lh = "ls | head" (newest at top), lt = "ls | tail" (newest at the bottom)
lt() {
    if [ $(ls -1 "$@" | wc -l) -gt $(($LINES/4)) ]; then
        echo ...
    fi
    if [[ $(uname -s) != Darwin* ]]; then
        local -r color_always="--color=always"
    fi
    ls $color_always -rltqh "$@" | tail -n $(($LINES/4))
}
# Just so I don't have to use two hands
alias ly=lt

# For httpie: https://github.com/jakubroztocil/httpie#installation
alias https='http --default-scheme=https'

md() {
    declare -r sys_name=$(uname -s)
    if [[ $sys_name == Darwin* ]]; then
        declare -r T=$(mktemp $TMPDIR$(uuidgen).html)
        curl -s -X POST --data-binary @"$1" https://md.dlma.com/ > $T
        open $T
    elif [[ $sys_name == CYGWIN* ]]; then
        declare -r T=$(mktemp --suffix=.html)
        curl -s -X POST --data-binary @"$1" https://md.dlma.com/ > $T
        cygstart $T
    else
        declare -r T=$(mktemp --suffix=.html)
        curl -s -X POST --data-binary @"$1" https://md.dlma.com/ > $T
        if [[ -z "${WSL_DISTRO_NAME}" ]]; then
            gio open $T
            echo "rm \"$T\" >/dev/null 2>&1" | at now + 2 minutes
        else
            # Set BROWSER to your web browser's path
            "$BROWSER" '\\wsl$/Ubuntu'$T
        fi
    fi
}

concept() {
    # apropos -s 7 . | awk '!/iso|latin/ {print $1}' | shuf -n 1 | xargs man 7
    apropos -s 7 . | awk '!/iso|latin/ {print $1}' | shuf -n 1 | pee "xargs echo man 7" "xargs man 7"
}

venv() {
    # Inspired by https://twitter.com/gvanrossum/status/1319328122618048514
    if hash deactivate 2>/dev/null; then
        deactivate
    fi
    if [[ $1 ]]; then
        if [ ! -f $1/bin/activate ]; then
            echo "Creating with: python3 -m venv $1"
            python3 -m venv $1
        fi
        source $1/bin/activate
    fi
}

# https://unix.stackexchange.com/questions/1288/preserve-bash-history-in-multiple-terminal-windows
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="&:ls:[bf]g:exit:pwd:clear:\:[qw]*:ZZ"
#HISTFILESIZE=2000
#HISTSIZE=2000
# [ $(wc -l < $HOME/.bash_history) -gt 950 ] && echo "David, your .bash_history is over 950 lines. Consider updating your .bashrc."
shopt -s histappend

if [ -f $HOME/.localrc ]; then
    source $HOME/.localrc
fi
