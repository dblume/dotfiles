#!/usr/bin/env bash
set -eu -o pipefail # See: https://sipb.mit.edu/doc/safe-shell/

declare -r SCRIPT_NAME=$(basename "$BASH_SOURCE")
declare -r backup_dir=$HOME/backup_of_dotfiles_`date "+%Y-%m-%d"`
declare -a dotfiles=(".bashrc" ".bash_profile" ".vimrc" 
                     ".gitconfig" ".gitignore" ".inputrc" ".ssh/config")
declare -i DRY_RUN=0

## exit the shell (with status 2) after printing the message
usage() {
    echo "\
$SCRIPT_NAME -hn
    -h      Print this help text
    -n      Perform a dry run, to see what'll change
"
    exit 2;
}

## Process the options
while getopts "hn" OPTION
do
  case $OPTION in
    h) usage;;
    n) DRY_RUN=1;;
    \?) usage;;
  esac
done

if [ ! -d $backup_dir/.ssh ]; then
    ((DRY_RUN==0)) && mkdir -p $backup_dir/.ssh
fi

# Move original dot files to backup
for i in "${dotfiles[@]}"
do
    if [ -e $HOME/"$i" ]; then
        if ! cmp --silent $HOME/"$i" "$i" ; then
            echo "$i" will be changed as follows:
            diff $HOME/"$i" "$i" || true
            if [ $DRY_RUN -eq 0 ]; then
                mv $HOME/"$i" $backup_dir/"$i"
                # Consider using symbolic links instead
                # so pulling updates automatically apply
                cp "$i" $HOME/"$i"
	        echo "# vimdiff \"$HOME/$i\" \"$backup_dir/$i\""
	    else
		# Provide a diff that can still be used
	        echo "# vimdiff \"$i\" \"$HOME/$i\""
            fi
	    echo
        else
            echo No change to "$i".
        fi
    else
        echo "$i" will be added to HOME.
        ((DRY_RUN==0)) && cp "$i" $HOME/"$i"
    fi
done

if [ $DRY_RUN -eq 0 ]; then
    if [ -d $HOME/.vim ]; then
        mv $HOME/.vim $backup_dir
    fi
    cp -r .vim $HOME
    if [ -d $backup_dir/.vim ]; then
	# Copy back some proprietary file types, if any.
        cp -r -n $backup_dir/.vim $HOME
    fi
fi

echo Your old dotfiles are backed up to $backup_dir

# Make a directory for vim undo
if [ ! -d $HOME/.vim_undo ]; then
    ((DRY_RUN==0)) && mkdir -p $HOME/.vim_undo
fi

# Tell David what's left.
echo Done. Check http://config.dlma.com for more.
