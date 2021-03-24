" Vim filetype detection file
" Language:     P4 Changelist
" Author:       Wade Brown <wbrown@roku.com>
" Copyright:    Copyright (C) 2019  Wade Brown <wbrown@roku.com>
" Licence:      You may redistribute this under the same terms as Vim itself
"
" Detects p4 changelists edits and sets up the editor appropriately

if &compatible || version < 600
    finish
endif

au BufNewFile,BufRead /tmp/tmp.*.* call s:changelist_scan()

function! s:changelist_scan()
    if getline(1) =~ '# A Perforce Change Specification.'
        setfiletype p4changelist
    endif
endfunction
