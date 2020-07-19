" Version 2020-07-08.1 - Use built-in netrw instead of NERDTree
set nocompatible    " Use Vim defaults, forget compatibility with vi.
set bs=2            " allow backspacing over everything in insert mode
set wildmenu        " Allows command-line completion with tab
set autoindent      " Copy indent from current line when starting a new line
set smartindent     " Do smart auto indenting when starting  new line
set smarttab        " Honor 'shiftwidth', 'tabstop' or 'softtabstop'
set hlsearch        " highlight all matches for previous search
set nofoldenable    " start unfolded
set foldlevel=0
set nowrap          " no wrapping text lines on the screen (exceptions below)
set sidescroll=5
set listchars+=tab:>-,precedes:<,extends:> " indicators of long lines

if v:version >= 703
  " Do save the undo tree to file, but not in the local directory.
  " Don't forget to mkdir ~/.vim_undo
  set undodir=~/.vim_undo,.
  set undofile        " undo even after closing and reopening a file
endif

" The following two lines set the use of perl regex, aka "very magic"
nnoremap / /\v
vnoremap / /\v

" Make j and k move to the next row, not file line
nnoremap j gj
nnoremap k gk

" From Steve Losh: http://learnvimscriptthehardway.stevelosh.com/chapters/10.html
" Map jk to ESC in insert mode
inoremap jk <esc>

" clear search highlights
nnoremap <cr> :noh<cr><cr>

" Commented out because I want tags searches to always be case sensitive.
" Override with \c anywhere in your search.
"set ignorecase      " If you enter all lowercase, it's case insensitive,
"set smartcase       " if you use mixed-case terms, it's case sensitive.

syntax on

" If you think this is hard to read,
" change the color of comments in vim, or
" use another color scheme like desert or peaksea
"
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
  highlight StatusLine   ctermfg=17 ctermbg=Gray " override scheme (overridden by powerline)
  highlight StatusLineNC ctermfg=20 ctermbg=LightGray" override scheme
  set lines=50 columns=100
else
  " Dark backgrounds for tty experiences
  set background=dark
  colorscheme desert                           " install desert
  if v:version >= 703
    highlight ColorColumn ctermbg=233 guibg=Black " dark gray (or 17, dark blue)
  endif
  highlight StatusLine   ctermfg=20 ctermbg=Gray " override scheme (overridden by powerline)
  highlight StatusLineNC ctermfg=17 ctermbg=DarkGray" override scheme
endif
" highlight Comment     term=bold ctermfg=Blue ctermbg=0 guifg=SlateBlue guibg=Black

" set mouse=v     " visual mode, not working great for PuTTY

set tags=tags;/

set history=50
set ruler
if has('statusline')
  set laststatus=2
  set statusline=%<%f\   " Filename
  set statusline+=%w%h%m%r " Options
  "set statusline+=%{fugitive#statusline()} " Git
  "set statusline+=\ [%{&ff}/%Y]            " filetype
  "set statusline+=\ [%{getcwd()}]          " current dir
  "set statusline+=\ [A=\%03.3b/H=\%02.2B]  " ASCII / Hexadecimal value of char
  set statusline+=%=%-14.(%l,%c%V%)\ %p%%   " Right aligned file nav info
endif

set encoding=utf-8

" I don't set comma for mapleader because it's useful for reverse-finding.
" let mapleader = ","
" let g:mapleader = ","

nmap <leader>w :w!<cr>         " Fast saving
" I use relative number for cursor movement.
nmap <leader>r :set relativenumber!<cr>
nmap <leader>n :set number!<cr>


" Useful mappings for managing tabs
"
nmap <leader>th <esc>:tabprevious<cr>
nmap <leader>tl <esc>:tabnext<cr>
nmap <leader>tn :tabnew
nmap <leader>to :tabonly<cr>
nmap <leader>tc :tabclose<cr>
nmap <leader>tm :tabmove
" Opens a new tab with the current buffer's path
nmap <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" pastetoggle
nmap <leader>p :set invpaste paste?<cr>

" Control+p to paste onto next line
nmap <C-p> :pu<cr>

" Make netrw's Lexplore behave like NERDTreeToggle
let g:NetrwIsOpen=0
function! ToggleNetrw()
    if g:NetrwIsOpen
        let i = bufnr("$")
        while (i >= 1)
            if (getbufvar(i, "&filetype") == "netrw")
                silent exe "bwipeout " . i
            endif
            let i-=1
        endwhile
        let g:NetrwIsOpen=0
    else
        let g:NetrwIsOpen=1
        silent Lexplore %:p:h
    endif
endfunction
nmap <leader>e :call ToggleNetrw()<cr>

nmap <leader>l :TlistToggle<cr>           " install taglist
nmap <leader>bd :Bdelete<cr>              " install vim-bbye

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

if has("autocmd")
  autocmd! BufWritePost .vimrc source %           " re-source this file when saved.
  autocmd BufWrite *.py :call DeleteTrailingWS()  " Delete trailing whitespace
  " Don't let smartindent unindent the # character in Python files
  autocmd FileType python  inoremap # X<c-h>#
  autocmd FileType c,cpp,python,php,brs  set expandtab  " Use spaces instead of tabs
  autocmd Filetype make    setl noexpandtab       " ...not for files that use tabs.

  " Use the vim command %retab before applying the following
  " two with files that have 8-space tabs.
  autocmd FileType c,cpp,python,php  set tabstop=4
  autocmd FileType c,cpp,python,php  set shiftwidth=4

  autocmd FileType python  set foldmethod=indent  " 'za' to fold
  autocmd FileType python  set foldlevel=99

  autocmd FileType c,cpp nmap <buffer> <leader>s :call SwitchSourceHeader()<cr>
  autocmd FileType c,cpp set foldmethod=syntax

  " autocmd FileType roku :let g:airline_extensions = []
  " autocmd FileType roku :let g:airline_section_warning = airline#section#create([])
  autocmd FileType roku :let g:airline#extensions#whitespace#enabled = 0

  if v:version >= 703
    " I toggle out of relative number when Vim's focus is lost, because
    " if I'm not editing, then I may be referring to errors with line numbers.
    autocmd FocusLost * if &relativenumber | set number | endif
    autocmd FocusGained * if &number | set relativenumber | endif
  endif

  " Since I have the undo tree saved to disk now (see above), I might prefer to
  " automatically save the file when focus is lost.
  " autocmd FocusLost * silent! wa

  " I'm in the habit of hitting Return myself.
  " autocmd BufRead *.txt set textwidth=78         " Limit width of text to 78 chars

  autocmd BufRead *.txt set wrap linebreak nolist  " "soft" wrap of existing lines
  autocmd BufRead README set wrap linebreak nolist " "soft" wrap of existing lines

  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
endif

" This requires vim to be compiled with +python
" Use auto complete in insert mode with ctrl-x, ctrl-o
" See :help new-omni-completion for more.
filetype plugin on
set omnifunc=syntaxcomplete#Complete
" Auto completion via ctrl-space (instead of ctrl-x ctrl-o)
" set omnifunc=pythoncomplete#Complete
" inoremap <Nul> <C-x><C-o>

" This function attempts to reuse the same scratch
" buffer over and over, so you always see output in
" the same location in your window layout.
function! ExecuteFileIntoScratchBuffer()
  write
  let f=expand("%:p")
  let cur_win = winnr()
  if buflisted("_vim_output")
    exe bufwinnr("_vim_output") . "wincmd w"
    enew
  else
    vnew
    let cur_win = cur_win+1
  endif
  setlocal buftype=nofile
  setlocal bufhidden=delete
  setlocal noswapfile
  silent file _vim_output
  execute '.! "'.f.'"'
  exe cur_win . "wincmd w"
endfunc
nmap <F5> :call ExecuteFileIntoScratchBuffer()<cr>

" Execute a selection of code
" Use Visual to select a range and then hit ctrl-h to execute it.
if has("python")
python << EOL
import vim
def EvaluateCurrentRange():
    eval(compile('\n'.join(vim.current.range),'','exec'),globals())
EOL
vnoremap <C-h> :py EvaluateCurrentRange()<cr>
endif

" cscope
if has("cscope")
    set cscopetag  " Use both cscope and ctag for 'ctrl-]'
    set csto=1     " 0=cscope first; 1=ctags first
    set cscopeverbose
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
" let g:netrw_winsize = -28 (for absolute width)
let g:netrw_winsize = 35
" sort is affecting only: directories on the top, files below
let g:netrw_sort_sequence = '[\/]$,*'

" When using vim-airline
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.whitespace = '✖'
let g:airline_symbols.linenr = 'Ξ'
let g:airline_theme = 'powerlineish'
let g:airline#extensions#wordcount#enabled = 0
" let g:airline_exclude_filetypes = []

" Install Pathogen for this next call to work
call pathogen#infect()
