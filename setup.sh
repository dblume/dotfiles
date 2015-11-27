#!/bin/bash
set -eu -o pipefail # See: https://sipb.mit.edu/doc/safe-shell/

declare -r backup_dir=$HOME/backup_of_orig_dotfiles_`date -Idate`

if [ ! -d $backup_dir ]; then
    mkdir -p $backup_dir
fi

# Move original dot files to backup
if [ -e $HOME/.bashrc ]; then
    mv $HOME/.bashrc $backup_dir
fi
if [ -e $HOME/.bash_profile ]; then
    mv $HOME/.bash_profile $backup_dir
fi
if [ -e $HOME/.gitconfig ]; then
    mv $HOME/.gitconfig $backup_dir
fi
if [ -d $HOME/.vim ]; then
    mv $HOME/.vim $backup_dir
fi

echo Note: Your old dotfiles are backed up to $backup_dir

# Move new dot files in
mv .bashrc $HOME
mv .bash_profile $HOME
mv .gitconfig $HOME
mv .vim $HOME

# Make a directory for vim undo
if [ ! -d $HOME/.vim_undo ]; then
    mkdir -p $HOME/.vim_undo
fi

# Tell David what's left.
echo Done. Check http://config.dlma.com for more.
