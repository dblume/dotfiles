" Version 2024-03-07.1 - First misc fixes
set bs=2            " allow backspacing over everything in insert mode
set smartindent     " Do smart auto indenting when starting  new line
set foldlevel=99
set nowrap          " no wrapping text lines on the screen (exceptions below)
set sidescroll=5
set listchars+=tab:>-,precedes:<,extends:>,nbsp:·,eol:\\u21b5 " for :set list
set iskeyword+=-    " Add - to list of non-word-breaking chars.
set scrolloff=0     " EC2 defaults to 5. Set explicitly to be consistent
set notermguicolors " Only needed for neovim while I port my color schemes
set undofile        " undo even after closing and reopening a file
set noshowcmd       " Show size of selected area in visual mode on last line
set noruler         " Show coordinates on status line
set hidden          " Don't abandon Scratch buffer when hidden.
"set cursorline     " For CursorLineNR formatting similar to pre 8.0.
set culopt=number   " Otherwise diff views have an underline. neovim issue 9800
" Set the title of the terminal window. Consider changing titlestring, %t, %M
set title titlestring=%f%m\ -\ nvim

" WSL clipboard-tool fom 'help clipboard'
"let g:clipboard = {
"            \   'name': 'WslClipboard',
"            \   'copy': {
"            \      '+': '/mnt/c/Windows/system32/clip.exe',
"            \      '*': '/mnt/c/Windows/system32/clip.exe',
"            \    },
"            \   'paste': {
"            \      '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
"            \      '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
"            \   },
"            \   'cache_enabled': 0,
"            \ }

" Yank and put into the system Clipboard (register + or *)
" Otherwise make explicit commands "+yy "+y "+Y (or * instead of + as needed)
" N.B. Don't use unnamed register for clipboard (set clipboard=unnamed)
"      Delete operations would overwrite clipboard before pasting.
nnoremap <leader>c "+
vnoremap <leader>c "+

" Make j and k move to the next row, not file line
nnoremap j gj
nnoremap k gk

" From Steve Losh: http://learnvimscriptthehardway.stevelosh.com/chapters/10.html
" Map jk to ESC in insert mode (except when navigating popup menu)
inoremap <expr> jk pumvisible() ? '' : '<esc>'
inoremap <expr> j pumvisible() ? '<Down>' : 'j'
inoremap <expr> k pumvisible() ? '<Up>' : 'k'
inoremap <expr> <Tab> pumvisible() ? '<Down>' : '<Tab>'
inoremap <expr> <S-Tab> pumvisible() ? '<Up>' : '<S-Tab>'
inoremap <expr> <cr> pumvisible() ? '<C-y>' : '<cr>'

" https://stevelosh.com/blog/2010/09/coming-home-to-vim/#s3-why-i-came-back-to-vim
nnoremap <leader>v <C-w>v<C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" clear search highlights
nnoremap <cr> :noh<cr><cr>

" tmux 3.2+ doesn't send C-i, so have Alacritty iTerm2 map C-i to <leader>i
" iTerm2: Settings > Keys > Key Bindings > + > Shortcut:^i Action:Send Text "\i"
nnoremap <leader>i <C-i>
" Use (Shift-)Tab to navigate buffers, retain C-i/C-o for jumps.
" Test with this:
" nvim -Nu NONE +'nno <C-i> :echom "C-i pressed"<cr>' +'nno <tab> :echom "Tab pressed"<cr>'
"if stridx(expand($TERM), 'xterm') == 0
  nnoremap <C-i> <C-i>
  nmap <Tab> :bn<cr>
"endif
nnoremap <S-Tab> :bp<cr>

set t_Co=256
set colorcolumn=80
if has('gui_running') " Didn't work: if &term != 'builtin_gui'
  " Light backgrounds for GUI experiences
  set background=light
  " colorscheme peaksea
  colorscheme tolerable
  highlight ColorColumn ctermbg=255 guibg=#F6F6F6
  highlight statusline   ctermfg=17 ctermbg=Gray  " override scheme
  highlight statuslineNC ctermfg=20 ctermbg=LightGray  " override scheme
  if has('win32')
    set guifont=DejaVu_Sans_Mono_for_Powerline:h10:cANSI:qDRAFT
  endif
  set lines=50 columns=100
else
  " Dark backgrounds for tty experiences
  set background=dark
  colorscheme nvim_desert
endif

au InsertEnter * hi statusline guibg=Cyan ctermfg=25 guifg=Black ctermbg=248
au InsertLeave * hi statusline term=bold,reverse cterm=bold,reverse ctermfg=23 ctermbg=250 guifg=black guibg=#c2bfa5

" See https://neovim.io/doc/user/vim_diff.html#_default-mouse
set mouse=  " neovim defaults to nvi

" Make c-] show a list of tags, or jump straight if only single tag
nnoremap <c-]> g<c-]>
vnoremap <c-]> g<c-]>
nnoremap g<c-]> <c-]>
vnoremap g<c-]> <c-]>
" Consider neovim default "./tags;,tags"
set tags=tags;/

set history=500

function! GitBranch()
  let l:branchname = system("git -C " . expand('%:p:h') . " rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
  return strlen(l:branchname) > 0 ? '  │  '.l:branchname : ''
endfunction

function! EncodingAndFormat()
  if (len(&fileencoding) && &fileencoding != 'utf-8') || &fileformat != 'unix'
    return &fileencoding?&fileencoding:&encoding .'['. &fileformat . '] │ '
  endif
  return ''
endfunction

function! OnRuler()
  if &ruler
    return '│ '.line('.').':'.col('.').' '
  endif
  return ''
endfunction

function! Current_mode()
  let l:currentmode={
    \ 'n'  : 'NORMAL',
    \ 'v'  : 'VISUAL',
    \ 'V'  : 'V·LINE',
    \ '' : 'V·BLOCK',
    \ 's'  : 'SELECT',
    \ 'S'  : 'S·LINE',
    \ 'i'  : 'INSERT',
    \ 'r'  : 'I·REPLACE',
    \ 'R'  : 'REPLACE',
    \ 'Rv' : 'V·REPLACE',
    \ 'c'  : 'COMMAND',
    \}
    return get(l:currentmode, mode(), mode())
endfunction

function! Trim_brackets(fn)
  if v:version > 800
    return trim(a:fn, "[]")
  else
    return a:fn
  endif
endfunction

set statusline=\ %{Current_mode()}
set statusline+=%{&paste?'\ \ ·\ PASTE':''}
set statusline+=%{b:git_branch}
set statusline+=\ │\ %f
set statusline+=%m
set statusline+=\ %r
set statusline+=\ %=
set statusline+=%h
set statusline+=\ %{Trim_brackets(&filetype)}
set statusline+=\ %#StatusLineNC#
set statusline+=\ %{b:enc_fmt}
set statusline+=%p%%\ of
set statusline+=\ %L\ 
set statusline+=%{OnRuler()}

" Fast saving
nmap <leader>w :w!<cr>
" I use relative number for cursor movement.
nmap <leader>r :set relativenumber!<cr>
nmap <leader>n :set number!<cr>

" Useful mappings for managing tabs
" Tab Previous: gT or C-PageUp
" Tab Next: gt or C-PageDown
nmap <leader>tn :tabnew
nmap <leader>to :tabonly<cr>
nmap <leader>tc :tabclose<cr>
nmap <leader>tm :tabmove
nmap <leader>1 1gt
nmap <leader>2 2gt
nmap <leader>3 3gt
nmap <leader>4 4gt
nmap <leader>5 5gt
nmap <leader>6 6gt
nmap <leader>7 7gt
nmap <leader>8 8gt
nmap <leader>9 9gt

" Open current buffer in new tab. Close with C-w,c
" https://vim.fandom.com/wiki/Maximize_window_and_return_to_previous_split_structure
function! OpenCurrentAsNewTab()
    let l:currentView = winsaveview()
    tabedit %
    call winrestview(l:currentView)
endfunction
nmap <leader>o :call OpenCurrentAsNewTab()<CR>

" pastetoggle
nmap <leader>p :set invpaste paste?<cr>

" Control+p to paste onto next line
nmap <C-p> :pu<cr>

" Make netrw's Explore behave a little like NERDTreeToggle
" http://vimcasts.org/blog/2013/01/oil-and-vinegar-split-windows-and-project-drawer/
function! ToggleNetrw()
  if bufwinnr("NetrwTreeListing") > 0
    for i in range(1, bufnr("$"))
      if (getbufvar(i, "&filetype") == "netrw")
        silent exe "bwipeout " . i
        return
      endif
    endfor
  endif
  silent Vexplore %:p:h
endfunction
nmap <leader>e :call ToggleNetrw()<cr>

" install taglist
let Tlist_GainFocus_On_ToggleOpen = 1  " Jump to taglist window on open
let Tlist_Exit_OnlyWindow = 1          " if you are the last, kill yourself
let Tlist_Close_On_Select = 1          " Close taglist window on select
let Tlist_Inc_Winwidth = 0             " Only needed for neovim in tmux
nmap <leader>l :TlistToggle<cr>

" install vim-bbye
nmap <leader>bd :Bdelete<cr>

" Visual mode mappings
"""

" map sort function to a key
vnoremap <leader>s :sort<cr>

"easier moving of code blocks
vnoremap < <gv
vnoremap > >gv

" If too many file system events are getting triggered.
set nobackup       " ~ files
set nowritebackup  " Don't write buff to temp, delete orig, rename temp to orig
set noswapfile     " .swp files

" Switch between source and header files
function! SwitchSourceHeader()
  let s:ext  = expand("%:e")
  let s:base = expand("%:t:r")
  let s:cmd  = "find " . s:base
  if (s:ext == "cpp" || s:ext == "c")
    if findfile(s:base . ".h"  ) != "" | exe s:cmd . ".h"   | return | en
    if findfile(s:base . ".hpp") != "" | exe s:cmd . ".hpp" | return | en
  else
    if findfile(s:base . ".cpp") != "" | exe s:cmd . ".cpp" | return | en
    if findfile(s:base . ".c"  ) != "" | exe s:cmd . ".c"   | return | en
  endif
endfunc

" Demonstrates a way to look in a mirror directory
" function! OpenOther()
"    if expand("%:e") == "cpp"
"      exe "split" fnameescape(expand("%:p:r:s?src?include?").".h")
"    elseif expand("%:e") == "h"
"      exe "split" fnameescape(expand("%:p:r:s?include?src?").".cpp")
"    endif
" endfunc

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
function! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc

function! OpenInOtherWindow()
  if winnr('$') == 1
    exe "wincmd F"
  else
    let curNum = winnr()
    let oldBuf = bufnr( "%" )
    if curNum == 1
      let othNum = 2
    else
      let othNum = 1
    endif
    exe "normal! gF"
    let newBuf = bufnr( "%" )
    let newLine = line(".")
    exe 'hide buf' oldBuf
    exe othNum . "wincmd w"
    exe 'hide buf' newBuf
    exe "normal! " . newLine . "G"
  endif
endfunc

nmap <silent> <leader>F :call OpenInOtherWindow()<cr>
nmap <silent> <leader>f :call OpenInOtherWindow()<cr>

if has("autocmd")
  autocmd BufWrite *.py :call DeleteTrailingWS()  " Delete trailing whitespace
  " Don't let smartindent unindent the # character in Python files
  autocmd FileType python  inoremap # X<c-h>#
  autocmd FileType python,c,cpp,php,brs,sh  set expandtab  " Use spaces instead of tabs
  autocmd Filetype make    setl noexpandtab       " ...not for files that use tabs.

  " Use the vim command %retab before applying the following
  " two with files that have 8-space tabs.
  autocmd FileType c,cpp,python,php  set tabstop=4
  autocmd FileType c,cpp,php  set shiftwidth=4

  autocmd FileType python  set foldmethod=indent  " 'za' to fold

  autocmd FileType c,cpp nmap <buffer> <leader>s :call SwitchSourceHeader()<cr>
  autocmd FileType c,cpp set foldmethod=syntax

" https://jeffkreeftmeijer.com/vim-number/
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

  autocmd BufRead *.txt set wrap linebreak   " "soft" wrap of existing lines
  autocmd BufRead README set wrap linebreak  " "soft" wrap of existing lines
  autocmd BufRead *.rs :setlocal tags=./rusty-tags.vi;/

  " When editing a file, always jump to the last cursor position...
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif
  " ...except for gitcommit where we always want to start at the top
  autocmd FileType gitcommit exe "normal! gg"

  autocmd BufNewFile,BufReadPost *
  \ let b:git_branch = GitBranch() |
  \ let b:enc_fmt = EncodingAndFormat()
  autocmd BufEnter *
  \ let b:git_branch = GitBranch() |
  \ let b:enc_fmt = EncodingAndFormat()

  " I only use a cursorline style for the number column
  autocmd OptionSet number,relativenumber if v:option_new | set cursorline | endif
endif

" This requires vim to be compiled with +python
" Use auto complete in insert mode with ctrl-x, ctrl-o
" See :help new-omni-completion for more.
filetype plugin on
set omnifunc=syntaxcomplete#Complete

" Torn on whether I like the omni completion preview window left open or not.
" autocmd CompleteDone * pclose

" Omni completion via ctrl-space (in addition to ctrl-x ctrl-o)
inoremap <C-Space> <C-x><C-o>

" These two commands display syntax/highlight info for what's under the cursor.
if exists(":SynStack") != 2
    command SynStack :echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endif

function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun
command Hi :call SynGroup()

" From https://stackoverflow.com/questions/15393301/how-to-automatically-sort-quickfix-entries-by-line-text-in-vim
" :grep term %
" :grep -r term path/
" :cw
" :ccl (or C-w,q)
autocmd! QuickfixCmdPost * call MaybeSortQuickfix('QfStrCmp')

function! MaybeSortQuickfix(fn)
"    exe 'normal! '  " Doesn't work. Wanted to jump back to where we were.
    let t = getqflist({'title': 1}).title
    " Only sort the files if for search-style commands, not "make".
    if stridx(t, "cs ") == 0 || stridx(t, ":gr") == 0 || stridx(t, ":vim") == 0 || stridx(t, ":rg") == 0
        call setqflist(sort(getqflist(), a:fn), 'r')
        call setqflist([], 'r', {'title': t})
    endif
    cwindow
endfunction

function! QfStrCmp(e1, e2)
    let [t1, t2] = [bufname(a:e1.bufnr), bufname(a:e2.bufnr)]
    return t1 <# t2 ? -1 : t1 ==# t2 ? 0 : 1
endfunction

" Use ripgrep for search instead of grep
if executable('rg')
    " set grepprg=rg\ --vimgrep\ --hidden\ —glob '!.git'
    set grepprg=rg
endif
" Navigate quickfix list with ease
nnoremap <silent> [q :cprevious<CR>
nnoremap <silent> ]q :cnext<CR>

" From `:help :DiffOrig`.
if exists(":DiffOrig") != 2
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_
    \ | diffthis | wincmd p | diffthis
endif

" I use Roboto Mono from https://github.com/powerline/fonts
" On iTerm2, Preferences -> Profiles -> Text -> Font
" Cygwin64 won't let you choose it. Launch Cygwin64 as follows:
" C:\cygwin64\bin\mintty.exe -i /Cygwin-Terminal.ico -o Font="Roboto Mono for Powerline" -

" Settings that make netrw more like NERDTree
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
" set g:netrw_winsize to negative for absolute width, positive for relative
let g:netrw_winsize = -36
" let g:netrw_winsize = 35
" sort is affecting only: directories on the top, files below
let g:netrw_sort_sequence = '[\/]$,*'

" Experimenting with vim-rooter
let g:rooter_patterns = ['.git', 'Makefile', 'builds/']
let g:rooter_cd_cmd = 'lcd'
let g:rooter_manual_only = 1

" 'Rainbow Parentheses Improved' https://github.com/luochen1990/rainbow/
let g:rainbow_conf = { 'ctermfgs': ['lightblue', 'green', '180', 'yellow', 'lightmagenta'] }
let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle

" See https://wiki.dlma.com/neovim#cscope
lua << EOF
  require('cscope_maps').setup()
EOF
