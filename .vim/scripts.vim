" For vim put this in ~/.vim/scripts.vim.
" For neovim: See ~/.config/nvim/init.vim
" See https://www.reddit.com/r/neovim/comments/wcq6sp/override_file_type_detection_for_existing/
if did_filetype()  " filetype already set..
  finish           " ..don't do these checks
endif
" Close, didn't bother making it match publishing channels like 12_a42f:
if getline(1) =~? '^\d\{2\}-\d\{2\} \d\{2\}:\d\{2\}:\d\{2\}.\d\{3\}\s\+\(n\|dev\|\d\+\|tvinput\.\S\+\) \['
  setfiletype rokulog
endif
