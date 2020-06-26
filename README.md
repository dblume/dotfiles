# David Blume's dotfiles

These are some of David Blume's dot files to be installed
in new user home directories.

### Getting the project

You can get a copy of this project by clicking on the
[ZIP](http://git.dlma.com/dotfiles.git/zipball/master)
or [TAR](http://git.dlma.com/dotfiles.git/tarball/master) buttons
near the top right of the GitList web page.

With an account, you can clone from the origin with:

    git clone ssh://USERNAME@dlma.com/~/git/dotfiles.git

### Installation

If you're not cloning the repo, then run the following:

    ~$ mkdir dotfiles
    ~$ cd dotfiles
    dotfiles$ curl -L http://git.dlma.com/dotfiles.git/tarball/master > dotfiles.tar
    dotfiles$ tar -xvf dotfiles.tar
    dotfiles$ rm dotfiles.tar

Then, when you run `setup.sh`, it'll backup your changed files to `backup_of_dotfiles_<date>`
and replace them with the ones here. You can perform a **dry run** to see which files will
be changed by passing the "-n" parameter.

    dotfiles$ ./setup.sh -n

If you approve of the changes, then just run `setup.sh`

    dotfiles$ ./setup.sh

See [config.dlma.com](http://config.dlma.com) for more.

#### What's installed

1. .bashrc and .bash\_profile
2. Vim resources
    1. .vimrc
    2. An empty .vim\_undo directory
    3. .vim with the following plugins:
        1. [pathogen](https://github.com/tpope/vim-pathogen), the Vim plugin manager.
        2. [vim-airline](https://github.com/vim-airline/vim-airline), for a better Vim statusline.
        3. [bbye for :Bdelete](https://github.com/moll/vim-bbye), to delete buffers without affecting windows.
        4. [nerdtree](https://github.com/scrooloose/nerdtree), a better filesystem tree-view explorer.
        5. [taglist](http://www.vim.org/scripts/script.php?script_id=273), a ctags tree-view explorer.
        6. [file-line](http://www.vim.org/scripts/script.php?script_id=2184), to open file:line as from a compiler error.
        7. [visual-star-search](http://got-ravings.blogspot.com/2008/07/vim-pr0n-visual-search-mappings.html), so * and # work in visual mode too.
        8. Assorted favorite colors like [desert](https://github.com/dblume/desert.vim).
3. .gitconfig and .gitignore
4. .tmux.conf
5. .inputrc, for a [partially matched command history traversal](http://askubuntu.com/questions/59846/bash-history-search-partial-up-arrow/59855#59855).
6. .ssh/config, for a [fix for CVE-2016-0777](https://news.ycombinator.com/item?id=10901588). (Or upgrade to OpenSSH 7.1p2 released Jan 14, 2016 from http://www.openssh.com.)

#### What's not installed

1. .dircolors (There are instructions in .bashrc to lighten the color of directories.)
2. Private data like keys, get those from the USB4 bioport in the back of your neck.

### Is it any good?

[Yes](https://news.ycombinator.com/item?id=3067434).

### License

This software uses the [MIT license](http://git.dlma.com/dotfiles.git/blob/master/LICENSE.txt).

