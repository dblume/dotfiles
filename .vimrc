" Version 2024-03-17.1 - status line color tweak
set nocompatible    " Use Vim defaults, forget compatibility with vi.
set bs=2            " allow backspacing over everything in insert mode
set wildmenu        " Allows command-line completion with tab
set autoindent      " Copy indent from current line when starting a new line
set smartindent     " Do smart auto indenting when starting  new line
set smarttab        " Honor 'shiftwidth', 'tabstop' or 'softtabstop'
set hlsearch        " highlight all matches for previous search
set foldlevel=99
set nowrap          " no wrapping text lines on the screen (exceptions below)
set sidescroll=5
set listchars+=tab:>-,precedes:<,extends:>,nbsp:· " for :set list
set iskeyword+=-    " Add - to list of non-word-breaking chars.
set incsearch       " Navigate to matched strings while typing. Toggle: :set is!
set scrolloff=0     " EC2 defaults to 5. Set explicitly to be consistent
set formatoptions+=j " Delete comment character when joining commented lines.
set ttimeoutlen=100 " Affects Esc key, not leader.
set noruler         " Don't show cursor pos on right side of status bar

if v:version >= 703
  " Do save the undo tree to file, but not in the local directory.
  " Don't forget to mkdir ~/.vim_undo
  set undodir=~/.vim_undo,.
  set undofile        " undo even after closing and reopening a file
endif

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

" Shift tab switches to prev buffer
" (Not remapping Tab because Ctrl-i in use as 'go to next jump pos')
nnoremap <S-Tab> :bp<cr>

" Use yy to yank a whole line, use Y to yank to end of line like C and D
nnoremap Y y$

syntax on

set t_Co=256
if v:version >= 703
  set colorcolumn=80
endif
if has('gui_running') " Didn't work: if &term != 'builtin_gui'
  " Light backgrounds for GUI experiences
  set background=light
  " colorscheme peaksea                        " install peaksea
  colorscheme tolerable                        " install tolerable
  if v:version >= 703
    highlight ColorColumn ctermbg=255 guibg=#F6F6F6
  endif
  highlight statusline   ctermfg=17 ctermbg=Gray  " override scheme
  highlight statuslineNC ctermfg=20 ctermbg=LightGray  " override scheme
  if has('win32')
    set guifont=DejaVu_Sans_Mono_for_Powerline:h10:cANSI:qDRAFT
  endif
  set lines=50 columns=100
else
  " Dark backgrounds for tty experiences
  set background=dark
  colorscheme desert                           " install desert
  if v:version >= 703
    highlight ColorColumn ctermbg=233 guibg=Black " dark gray (or 17, dark blue)
  endif
  highlight statusline   ctermfg=23 ctermbg=250  " override scheme
"  highlight User1        ctermfg=250 ctermbg=30
  highlight statuslineNC ctermfg=237 ctermbg=Gray  " override scheme
  highlight MatchParen   term=reverse ctermbg=23  " 23 is more subtle than default
endif

au InsertEnter * hi statusline guibg=Cyan ctermfg=25 guifg=Black ctermbg=248
au InsertLeave * hi statusline term=bold,reverse cterm=bold,reverse ctermfg=23 ctermbg=250 guifg=black guibg=#c2bfa5

" set mouse=v     " visual mode, not working great for PuTTY

set tags=tags;/

set history=500
set laststatus=2

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

set encoding=utf-8

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

" Allow tags to open another buffer even if this one is modified
set hidden

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
  \ if &ft != "gitcommit" && line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
  " ...except for gitcommit where we always want to start at the top (nvim)
  autocmd FileType gitcommit exe "normal! gg"

  autocmd BufNewFile,BufReadPost *
  \ let b:git_branch = GitBranch() |
  \ let b:enc_fmt = EncodingAndFormat()
  autocmd BufEnter *
  \ let b:git_branch = GitBranch() |
  \ let b:enc_fmt = EncodingAndFormat()
endif

" This requires vim to be compiled with +python
" Use auto complete in insert mode with ctrl-x, ctrl-o
" See :help new-omni-completion for more.
filetype plugin on
set omnifunc=syntaxcomplete#Complete

" Torn on whether I like the omni completion preview window left open or not.
" autocmd CompleteDone * pclose

" Omni completion via ctrl-space (in addition to ctrl-x ctrl-o)
inoremap <Nul> <C-x><C-o>

" These two commands display syntax/highlight info for what's under the cursor.
if exists(":SynStack") != 2
    command SynStack :echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endif

function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun
command Hi :call SynGroup()

" cscope
if has("cscope")
    set cscopetag  " Use both cscope and ctag for 'ctrl-]'
    set csto=1     " 0=cscope first; 1=ctags first
    set cscopequickfix=s-,c-,d-,i-,t-,e-,a- " cscope to quickfix window

    set nocsverb
    " add any database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
    " else add database pointed to by environment
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    set csverb
endif

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

" In some environments, Vim starts in replace mode:
" https://superuser.com/questions/1284561/why-is-vim-starting-in-replace-mode
" set t_u7=
