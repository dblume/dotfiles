# dotfiles (home directory .files)

These are some of David Blume's dot files to be installed
in new user home directories.

### Getting the project

You can get a copy of this project by clicking on the
[ZIP](http://git.dlma.com/dotfiles.git/zipball/master)
or [TAR](http://git.dlma.com/dotfiles.git/tarball/master) buttons
near the top right of the GitList web page.

You can clone from the origin with:

    git clone ssh://USERNAME@dlma.com/~/git/dotfiles.git

### Installation 

Run the following:

    ~$ mkdir dotfiles
    ~$ cd dotfiles
    dotfiles$ curl -L http://git.dlma.com/dotfiles.git/tarball/master > dotfiles.tar
    dotfiles$ tar -xvf dotfiles.tar
    dotfiles$ rm dotfiles.tar

Then, then you run `setup.sh`, it'll backup your old files to `backup_of_orig_dotfiles_<date>`
and replace them with the ones here.

    dotfiles$ ./setup.sh

And see config.dlma.com for more.

#### What's installed

1. .bashrc and .bash_profile
2. Vim resources
    1. .vimrc
    2. An empty .vim_undo directory
    3. .vim with the following plugins:
        1. [pathogen](https://github.com/tpope/vim-pathogen).
        2. [bbye for :Bdelete](https://github.com/moll/vim-bbye).
        3. [nerdtree](https://github.com/scrooloose/nerdtree).
        4. [taglist](http://www.vim.org/scripts/script.php?script_id=273).
        5. [vim-powerline](https://github.com/Lokaltog/vim-powerline).
        6. Assorted favorite colors like [desert](https://github.com/dblume/desert.vim).
3. .gitconfig (but it needs vimdiff and github settings.)

#### What's not installed

1. Private or public keys, get those from the USB4 bioport in the back of your neck.

### Is it any good?

[Yes](https://news.ycombinator.com/item?id=3067434).

### License

This software uses the [WTFPL](http://www.wtfpl.net/).

