# David Blume's dotfiles

These are some of David Blume's dot files to be installed in new user
home directories.

### Preview

Here's a screen capture showing tmux, vim, and the shell preparing to run entr.
(Because [tmux+vim+entr is a great IDE](https://twitter.com/search?q=tmux%20vim%20entr&src=typed_query).)

My vim config is light weight: no nerd fonts, no statusline plugin, no plugin
manager, no file manager, etc. Yet it's full featured in that the status line
shows nearly all the info of Powerline, and uses the built-in plugin manager
and powers-up netrw, the built-in file explorer. It includes about five
essential plugins.

The screen cap shows the tmux status line, the vim status line, taglist, and
a vim popup menu.

![tmux\_vim\_entr.png](https://dblume.github.io/images/tmux_vim_entr_wide_14pt.png)

### Download the project

There are two remote repos:

- **[git.dlma.com](https://git.dlma.com/dotfiles.git)**: Click Download and
  select Download ZIP or Download TAR.
- **[GitHub](https://github.com/dblume/dotfiles)**: Click the green Code button
  and select Local -> Download ZIP

### Install from CLI

Run the following:

    ~$ mkdir dotfiles
    ~$ cd dotfiles
    dotfiles$ curl -L https://git.dlma.com/dotfiles.git/archive/HEAD.tar > dotfiles.tar
    dotfiles$ tar -xvf dotfiles.tar
    dotfiles$ rm dotfiles.tar

Then, when you run `setup.sh`, it'll backup your changed files to `backup_of_dotfiles_<date>`
and replace them with the ones here. You can perform a **dry run** to see which files will
be changed by passing the "-n" parameter.

    ./setup.sh -n

If you approve of the changes, then just run `setup.sh`

    ./setup.sh

See [config.dlma.com](http://config.dlma.com) for more.

#### What's installed

1. .bashrc and .bash\_profile
2. Vim resources
    1. .vimrc
    2. An empty .vim\_undo directory
    3. .vim with the following plugins:
        1. [bbye for :Bdelete](https://github.com/moll/vim-bbye), to delete buffers without affecting windows.
        2. [taglist](http://www.vim.org/scripts/script.php?script_id=273), a ctags tree-view explorer.
        3. [file-line](http://www.vim.org/scripts/script.php?script_id=2184), to open file:line as from a compiler error.
        4. [visual-star-search](http://got-ravings.blogspot.com/2008/07/vim-pr0n-visual-search-mappings.html), so * and # work in visual mode too.
        5. [git-tab](https://github.com/dblume/gittab), use integrated context-sensitive git commands
        6. Assorted favorite colors like [desert](https://github.com/dblume/desert.vim).
3. Neovim resources
    1. .config/nvim/init.vim
    2. .config/nvim/colors/nvim\_desert.vim
    3. .local/share/nvim/site/plugin/ plugins
4. .gitconfig and .gitignore
5. .tmux.conf
6. .inputrc, for vi mode and a [partially matched command history traversal](http://askubuntu.com/questions/59846/bash-history-search-partial-up-arrow/59855#59855).
7. .editrc, for vi mode and tab word completion in macOS.
8. .ssh/config, for a [fix for CVE-2016-0777](https://news.ycombinator.com/item?id=10901588). (Or upgrade to OpenSSH 7.1p2 released Jan 14, 2016 from http://www.openssh.com.)
9. .ripgreprc, for ripgrep, or [rg](https://github.com/BurntSushi/ripgrep/).
10. .gdbinit
11. .visidatarc, to hide [visidata's](https://www.visidata.org/) menu at the top, for the old school UI.
12. .config/gitui/key\_bindings.ron, for vim key bindings in [gitui](https://github.com/extrawurst/gitui).
13. [i3](https://i3wm.org/) configs.

#### Optional manual steps for fresh setups

Vim will work without warnings if you install `ctags` and `cscope`.

    sudo apt update
    sudo apt install ctags cscope moreutils

If you're coming from the far future and want the latest modules, not those
pinned to a version, `pip install` requirements.in instead of requirements.txt.

    sudo apt install python3-pip
    python3 -m pip install -r requirements.in

#### What's not installed

1. .dircolors (There are instructions in .bashrc to lighten the color of directories.)
2. Private data like keys, get those from the USB4 bioport in the back of your neck.
3. The commonly used Python modules described above

### Is it any good?

[Yes](https://news.ycombinator.com/item?id=3067434).

### License

This software uses the [MIT license](https://git.dlma.com/dotfiles.git/blob/main/LICENSE.txt).

