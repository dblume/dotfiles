#!/usr/bin/env bash
set -eu -o pipefail # See: https://sipb.mit.edu/doc/safe-shell/

declare -r script_name=$(basename "${BASH_SOURCE[0]}")
declare -r backup_dir="$HOME"/backup_of_dotfiles_$(date "+%Y-%m-%d_%H%M%S")
declare -a dotfiles=(".bashrc" ".bash_profile" ".vimrc" ".editrc" ".gitconfig"
                     ".gitignore" ".inputrc" ".tmux.conf" ".ssh/config" ".ripgreprc"
                     ".gdbinit" ".config/gitui/key_bindings.ron" ".visidatarc"
                     ".config/i3/config" ".config/i3status/config"
                     ".config/dunst/dunstrc" ".config/alacritty/alacritty.toml")
declare -i dry_run=0

## exit the shell (with status 2) after printing the message
usage() {
    echo "\
$script_name -hn
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
    n) dry_run=1;;
    \?) usage;;
  esac
done

if [ ! -d "${backup_dir}"/.ssh ]; then
    ((dry_run==0)) && mkdir -p "${backup_dir}"/.ssh
fi

# Move original dot files to backup
for i in "${dotfiles[@]}"
do
    if [ -e "$HOME"/"$i" ]; then
        if ! cmp --silent "$HOME"/"$i" "$i" ; then
            echo "$i" will be changed as follows:
            diff "$HOME"/"$i" "$i" || true
            if [ $dry_run -eq 0 ]; then
                mv "$HOME"/"$i" "${backup_dir}"/"$i"
                # Consider using symbolic links instead
                # so pulling updates automatically apply
                cp "$i" "$HOME"/"$i"
                echo "# vimdiff \"$HOME/$i\" \"${backup_dir}/$i\""
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
        ((dry_run==0)) && mkdir -p "$HOME"/"$(dirname "$i")" && cp "$i" "$HOME"/"$i"
    fi
done

update_dir () {
    if ! diff -qr "$HOME"/"$1" "$1" > /dev/null ; then
        local parentdir="$(dirname "$1")"

        if [ $dry_run -eq 0 ]; then
            if [ -d "$HOME"/"$1" ]; then
                mkdir -p "${backup_dir}"/"$parentdir"
                mv "$HOME"/"$1" "${backup_dir}"/"$parentdir"
            else
                mkdir -p "$HOME"/"$parentdir"
            fi
            cp -RL "$1" "$HOME"/"$parentdir"
            if [ -d "${backup_dir}"/"$1" ]; then
                # Copy back proprietary file types (ex. ftdetect/my.vim), if any.
                # Print only the files that got moved back into ~/"$1"
                cp -RLnv "${backup_dir}"/"$1" "$HOME"/"$parentdir" | grep " -> " | cut -d " " -f3 | \
                    xargs -I{} sh -c "test -f {} && echo Restored {}" || true
            fi
        fi
        if [[ -d "${backup_dir}"/"$1" ]]; then
            if ! diff -qr "$backup_dir"/"$1" "$HOME"/"$1" ; then
                echo "# diff -qr \"$backup_dir/$1\" \"$HOME/$1\""
                echo
            else
                echo No change to the "$1"/ directories after restoring proprietary files.
            fi
        else
            echo No "${backup_dir}"/"$1"/ from which to restore proprietary files \(yet\).
        fi
    else
        echo No change to the "$1"/ directories.
    fi
}

update_dir ".vim"
update_dir ".config/nvim"
# Neovim's plugins go in ~/.local/share/nvim/site/plugin/
# https://neovim.io/doc/user/usr_05.html
update_dir ".local/share/nvim/site/plugin"

# Make a directory for vim undo
if [ ! -d "$HOME"/.vim_undo ]; then
    ((dry_run==0)) && mkdir -p "$HOME"/.vim_undo
fi

# I have device local secrets in .localrc and a github secret in .gitconfig.local
for i in ".gitconfig.local" ".localrc"
do
    if [ ! -f "$HOME"/"$i" ]; then
        echo Consider copying $i from a similar acct. \(\'touch \"\$HOME/$i\"\' to hide this msg.\)
    fi
done

if [ $dry_run -eq 0 ]; then
    echo Your old dotfiles are backed up to "${backup_dir}"
    echo Done. Check http://config.dlma.com for more.
else
    echo Your old dotfiles would have been backed up to "${backup_dir}"
    echo Dry run completed.
fi

