" Some override of the neovim desert theme from the old vim one.
runtime colors/desert.vim

" Consider ctermfg=250 (a little darker) for Normal
hi Normal       ctermbg=233 ctermfg=252
hi EndOfBuffer  ctermbg=234 ctermfg=244

hi Constant     ctermfg=179
hi LineNr       ctermbg=237 ctermfg=3 guifg=#eeee00
hi SignColumn   ctermbg=237
hi CursorLineNr ctermbg=242
hi TabLineSel   ctermbg=white ctermfg=239
hi TabLine      ctermbg=247 ctermfg=237
hi TabLineFill  ctermbg=235
hi Folded       ctermfg=143 ctermbg=235
hi FoldColumn   ctermfg=143 ctermbg=235
hi DiffDelete   ctermfg=235 ctermbg=52
hi DiffChange   ctermfg=231 ctermbg=238
hi DiffText     ctermfg=254 ctermbg=30
" hi Title        cterm=bold ctermfg=221
hi Title        cterm=bold ctermfg=214
"hi Type         ctermfg=150
hi Type         ctermfg=144
hi PreProc      ctermfg=173

hi Search       ctermfg=186 ctermbg=240
hi CurSearch    ctermbg=25

" Noticed these were different in vim and neovim in rokulog syntax
hi Ignore       cterm=bold ctermfg=242 guifg=grey40
hi Comment      term=bold ctermfg=44 guifg=SkyBlue
hi Identifier   term=underline cterm=bold ctermfg=6 guifg=palegreen
hi Error        term=reverse cterm=bold ctermfg=7 ctermbg=1

hi ColorColumn  cterm=NONE ctermbg=234 guibg=Black " dark gray (or 17, dark blue)
hi statusline   cterm=bold,reverse ctermfg=23 ctermbg=250  " override scheme
hi statuslineNC cterm=reverse ctermfg=238 ctermbg=Gray  " override scheme
hi MatchParen   term=reverse ctermbg=23  " 23 is more subtle than default

hi htmlItalic   term=italic cterm=italic ctermbg=24 gui=italic
hi htmlBold     term=bold cterm=bold ctermfg=white ctermbg=237 gui=bold
hi htmlBoldItalic term=bold,italic cterm=bold,italic ctermfg=white ctermbg=24 gui=bold,italic
hi htmlStrike   ctermfg=248 ctermbg=235

hi NormalFloat  cterm=NONE ctermbg=23
hi FloatBorder cterm=NONE ctermbg=23

hi MyTagListTagName ctermbg=25

"vim: sw=4
