#!/usr/bin/env bash
set -eu -o pipefail # See: https://sipb.mit.edu/doc/safe-shell/

declare -r backup_dir=$HOME/backup_of_dotfiles_`date "+%Y-%m-%d"`
declare -a dotfiles=(".bashrc" ".bash_profile" ".gitconfig" ".gitignore")

if [ ! -d $backup_dir ]; then
    mkdir -p $backup_dir
fi

# Move original dot files to backup
for i in "${dotfiles[@]}"
do
    if [ -e $HOME/"$i" ]; then
        mv $HOME/"$i" $backup_dir
    fi
done
if [ -d $HOME/.vim ]; then
    mv $HOME/.vim $backup_dir
fi

echo Note: Your old dotfiles are backed up to $backup_dir

# Move new dot files in.
# If you cloned the repo, consider making symbolic links instead,
# to more easily keep this home directory current by pulling updates.
for i in "${dotfiles[@]}"
do
    cp "$i" $HOME
done
cp -r .vim $HOME

# Make a directory for vim undo
if [ ! -d $HOME/.vim_undo ]; then
    mkdir -p $HOME/.vim_undo
fi

# Tell David what's left.
echo Done. Check http://config.dlma.com for more.
