" Version 2023-11-13.1 - Prep to stop using vim-airline
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
" Map jk to ESC in insert mode (except when navigating popup menu)
inoremap <expr> jk pumvisible() ? '' : '<esc>'
inoremap <expr> j pumvisible() ? '<Down>' : 'j'
inoremap <expr> k pumvisible() ? '<Up>' : 'k'

" https://stevelosh.com/blog/2010/09/coming-home-to-vim/#s3-why-i-came-back-to-vim
nnoremap <leader>v <C-w>v<C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" clear search highlights
nnoremap <cr> :noh<cr><cr>

" tab switches to previous/next buffer
nnoremap <Tab> :bp<cr>
nnoremap <S-Tab> :bn<cr>

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
  highlight statusline   ctermfg=17 ctermbg=Gray " override scheme
  highlight statuslineNC ctermfg=20 ctermbg=LightGray" override scheme
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
  highlight statusline   ctermfg=24 ctermbg=250  " override scheme
  highlight statuslineNC ctermfg=236 ctermbg=Gray  " override scheme
  highlight MatchParen   term=reverse ctermbg=23  " 23 is more subtle than default
endif

au InsertEnter * hi statusline guibg=Cyan ctermfg=25 guifg=Black ctermbg=248
au InsertLeave * hi statusline term=bold,reverse cterm=bold,reverse ctermfg=24 ctermbg=250 guifg=black guibg=#c2bfa5

let g:loaded_airline = 1  " For testing the statusline settings above

" set mouse=v     " visual mode, not working great for PuTTY

set tags=tags;/

set history=50
set laststatus=2

function! StatuslineGit()
  let l:branchname = system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
  return strlen(l:branchname) > 0 ? ' | branch:'.l:branchname : ''
endfunction

"    \ '' : 'S·BLOCK',
let g:currentmode={
    \ 'n'  : 'NORMAL',
    \ 'v'  : 'VISUAL',
    \ 'V'  : 'V·LINE',
    \ '' : 'V·BLOCK',
    \ 's'  : 'SELECT',
    \ 'S'  : 'S·LINE',
    \ 'i'  : 'INSERT',
    \ 'R'  : 'REPLACE',
    \ 'Rv' : 'V·REPLACE',
    \ 'c'  : 'COMMAND',
    \}

function! Trim_brackets(fn)
  if v:version > 800
    return trim(a:fn, "[]")
  else
    return a:fn
  endif
endfunction

set statusline=
set statusline+=\ %{g:currentmode[mode()]}
set statusline+=%{&paste?'\ \ ·\ PASTE':''}
"set statusline+=%{StatuslineGit()}
set statusline+=\ \|\ %f
set statusline+=%m\ 
set statusline+=%r\ 
set statusline+=%=
set statusline+=%h
set statusline+=\ %{Trim_brackets(&filetype)}\ 
set statusline+=%#StatusLineNC#
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ \|\ %p%%\ Ξ
set statusline+=\ %l/%L\ :\ %c
set statusline+=\ 

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

" git blame, show, diff and log
" Delete these functions when you install https://github.com/tpope/vim-fugitive

"A helper function that tries to show a buffer if it already exists
function! ShowBufInNewTab(bufname)
   let l:bnr = bufnr(a:bufname)
   if l:bnr > 0
       tabnew
       exec 'buffer ' . l:bnr
       return 1
   endif
   return 0
endfunction

function! GitBlame()
    let l:hash = expand('<cword>')
    let l:currentView = winsaveview()
    " If in a Blame window already, do blame for some prior commit
    if l:hash =~ '^[0-9a-f]\{7,40}$' && stridx(expand('%'), ' -- ') != -1
        let l:fname = split(expand('%'), ' -- ')[-1]
        let l:bufname = 'git blame ' . l:hash . '^ -- ' . l:fname
        if !ShowBufInNewTab(l:bufname)
            exec 'tabnew | r! git blame ' . l:hash . '^ -- ' . shellescape(l:fname)
            exec 'silent :file ' . fnameescape(l:bufname)
        endif
    else
        let l:fname = expand('%')
        let l:bufname = 'git blame -- ' . l:fname
        if !ShowBufInNewTab(l:bufname)
            exec 'tabnew | r! git blame -- ' . shellescape(l:fname)
            exec 'silent :file ' . fnameescape(l:bufname)
        endif
    endif
    0d_
    call winrestview(l:currentView)
    setl buftype=nofile
endfunction
command Blame :call GitBlame()

function! GitShow(commit_or_file)
    let l:fname = expand('%')
    let l:hash = expand('<cword>')
    if l:hash =~ '^[0-9a-f]\{7,40}$'
        if stridx(l:fname, ' -- ') != -1
            let l:fname = split(l:fname, ' -- ')[-1]
        endif
        if a:commit_or_file != "file"
            let l:bufname = 'git show ' . l:hash . ' -- ' . l:fname
            if !ShowBufInNewTab(l:bufname)
                " Have Show show all the affected files, so don't actually use  "--"
                " exec 'tabnew | r! git show ' . l:hash . ' -- ' . shellescape(l:fname)
                exec 'tabnew | r! git show ' . l:hash
                " We lie here (' -- ') to have a filename the other git commands can use.
                exec 'silent :file ' . fnameescape(l:bufname)
            endif
        else
            let l:bufname = 'git show ' . l:hash . ':' . l:fname
            if !ShowBufInNewTab(l:bufname)
                exec 'tabnew | r! git show ' . l:hash . ':' . shellescape(l:fname)
                exec 'silent :file ' . fnameescape(l:bufname)
            endif
        endif
        setl buftype=nofile
        0d_
    else
        echo l:hash . ' is not a git hash.'
    endif
endfunction
command Show :call GitShow("commit")
command ShowFile :call GitShow("file")

function! GitDiff()
    let l:fname = expand('%:.')
    let l:buf = winbufnr(0)
    let l:commit = 'HEAD'
    let l:hash = expand('<cword>')

    " If the current word is a hash, then diff that vs. previous
    if l:hash =~ '^[0-9a-f]\{7,40}$' && stridx(expand('%'), ' -- ') != -1
        let l:fname = split(expand('%'), ' -- ')[-1]
        exec ':tabnew | silent r! git show ' . l:hash . '^:$(git rev-parse --show-prefix)' . shellescape(l:fname)
        setl buftype=nofile
        0d_
        exec 'silent :file ' . fnameescape('git show '.l:hash .'^:'.l:fname)

        exec 'vne | silent r! git show ' . l:hash . ':$(git rev-parse --show-prefix)' . shellescape(l:fname)
        setl buftype=nofile
        exec 'silent :file ' . fnameescape('git show '.l:hash.':'.l:fname)
        0d_
    else
        " If the buffer is not different then repo, then diff HEAD vs file's previous commit
        let l:o = system("git status --porcelain | grep " . l:fname)
        if v:shell_error != 0
            let l:commit = system('git log -2 --pretty=format:"%h" -- ' . l:fname . ' | tail -n 1')
        endif

        " Bug if l:filename includes ".."
        exec ':tabnew | r! git show ' . l:commit . ':$(git rev-parse --show-prefix)' . l:fname
        setl buftype=nofile
        0d_
        exec 'silent :file ' . fnameescape('git show '.l:commit.':'.l:fname)
        exec 'vert sb '.l:buf
    endif
    windo diffthis
    setl buftype=nofile
    wincmd r
    wincmd l
endfunction
command Diff :call GitDiff()

function! GitLog(flags)
    let l:fname = expand('%')
    if stridx(l:fname, ' -- ') != -1
        let l:fname = split(l:fname, ' -- ')[-1]
    endif
    let l:bufname = 'git log ' . a:flags . '-- ' . l:fname
    if !ShowBufInNewTab(l:bufname)
        exec 'tabnew | r! git log --no-color --graph --date=short ' . a:flags . '--pretty="format:\%h \%ad \%s \%an \%d" -- ' . shellescape(l:fname)
        setl buftype=nofile
        0d_
        exec 'silent :file ' . fnameescape(l:bufname)
    endif
endfunction
command Logall :call GitLog('--all ')
command Log :call GitLog('')

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

  " autocmd FileType rokulog :let g:airline_extensions = []
  " autocmd FileType rokulog :let g:airline_section_warning = airline#section#create([])
  autocmd FileType rokulog :let g:airline#extensions#whitespace#enabled = 0

  if v:version >= 703
    " I toggle out of relative number when Vim's focus is lost, because
    " if I'm not editing, then I may be referring to errors with line numbers.
    autocmd FocusLost * if &relativenumber | set number | endif
    autocmd FocusGained * if &number | set relativenumber | endif
  endif

  autocmd BufRead *.txt set wrap linebreak   " "soft" wrap of existing lines
  autocmd BufRead README set wrap linebreak  " "soft" wrap of existing lines
  autocmd BufRead *.rs :setlocal tags=./rusty-tags.vi;/

  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if &ft != "p4changelist" && &ft != "gitcommit" && line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
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

" When using vim-airline
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.whitespace = '✖'
let g:airline_symbols.linenr = 'Ξ'
let g:airline_symbols.maxlinenr = ''
" If using a powerline font, don't override .readonly. Otherwise pick one.
"let g:airline_symbols.readonly = '◆'
"let g:airline_symbols.readonly = '🔒'

" If no "...for Powerline" font is available, uncomment these four:
let g:airline_left_sep = '▌'
let g:airline_right_sep = '▐'
let g:airline_left_alt_sep = '|'
let g:airline_right_alt_sep = '|'

let g:airline_theme = 'powerlineish'
let g:airline#extensions#wordcount#enabled = 0
" let g:airline_exclude_filetypes = []

" Experimenting with vim-rooter
let g:rooter_patterns = ['.git', 'Makefile', 'builds/']
let g:rooter_cd_cmd = 'lcd'
let g:rooter_manual_only = 1

" In some environments, Vim starts in replace mode:
" https://superuser.com/questions/1284561/why-is-vim-starting-in-replace-mode
" set t_u7=
