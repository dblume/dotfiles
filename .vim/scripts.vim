" For vim put this in ~/.vim/scripts.vim.
" neovim doesn't even call scripts.vim if filetype was done.
" See ~/.config/nvim/init.vim and
" https://www.reddit.com/r/neovim/comments/wcq6sp/override_file_type_detection_for_existing/
if did_filetype()  " filetype already set..
  finish           " ..don't do these checks
endif
if getline(1) =~? '^\d\{2\}-\d\{2\} \d\{2\}:\d\{2\}:\d\{2\}.\d\{3\}\s\+\(n\|dev\|\d\+\(_[0-9a-f]\+\)\?\|tvinput\.\S\+\) \['
  setfiletype rokulog
endif
