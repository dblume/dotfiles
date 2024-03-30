" Some override of the neovim desert theme from the old vim one.
runtime colors/desert.vim

hi Normal       ctermbg=233 ctermfg=254
hi EndOfBuffer  ctermbg=235

hi Constant     ctermfg=130
hi DiffDelete   ctermfg=231 ctermbg=52 guifg=#ffffff guibg=#af5faf
hi LineNr       ctermfg=3 guifg=#eeee00
hi TabLineSel   ctermbg=white ctermfg=239
hi TabLine      ctermbg=247 ctermfg=237
hi TabLineFill  ctermbg=235

hi ColorColumn  cterm=NONE ctermbg=234 guibg=Black " dark gray (or 17, dark blue)
hi statusline   cterm=bold,reverse ctermfg=23 ctermbg=250  " override scheme
hi statuslineNC cterm=reverse ctermfg=238 ctermbg=Gray  " override scheme
hi MatchParen   term=reverse ctermbg=23  " 23 is more subtle than default

"vim: sw=4
