" Vim syntax file
" Language:	Perforce Changelist
" Maintainer:	Wade Brown <wbrown@roku.com>
" Last Change:	2019 May 20

" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

" Comments
syn match Comment "^#.*"

" Changelist sections
syn match Type "^Change:"
syn match Type "^Client:"
syn match Type "^User:"
syn match Type "^Status:"
syn match Type "^Description:"
syn match Type "^Files:"

" Swarm wants all descriptions tab indented
syn match Error "^ \+"

" Code review bits
syn match PreProc "#review\(-[0-9]\+\)\?"
syn match String '\s\+@[a-z]\+'

" File operations
syn match Special "# delete$"
syn match Special "# edit$"
syn match Special "# add$"

let b:current_syntax = "p4changelist"

" vim: ts=8 sw=2
