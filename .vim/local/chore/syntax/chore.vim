if exists("b:current_syntax")
	finish
endif

syntax match ChoreDone '^x\(\s\|$\)'
syntax match ChoreProject '\v(^|\s)\+[^[:space:]]+'
syntax match ChoreContext '\v(^|\s)\@[^[:space:]]+'
syntax match ChoreKey '\v<[^[:space:]:]+\ze:'
syntax match ChoreValue '\v:\zs[^[:space:]]+'
syntax match ChoreDate '\v<\d{4}>(-\d\d(-\d\d(T\d\d(:\d\d)?)?)?)?'
syntax match ChorePriorityHigh '\v(^|\s)\zs\([A-H]\)\ze($|\s)'
syntax match ChorePriorityMedium '\v(^|\s)\zs\([I-M]\)\ze($|\s)'
syntax match ChorePriorityLow '\v(^|\s)\zs\([N-Y]\)\ze($|\s)'
syntax match ChorePriorityTrivial '\v(^|\s)\zs\(Z\)\ze($|\s)'

highlight ChoreContext ctermfg = LightBlue
highlight ChoreDate    ctermfg = Gray
highlight ChoreDone    ctermfg = DarkGray
highlight ChoreKey     ctermfg = Green
highlight ChoreProject ctermfg = Magenta
highlight ChoreValue   ctermfg = Cyan
highlight ChorePriorityHigh    ctermbg = Red
highlight ChorePriorityHigh    ctermfg = White
highlight ChorePriorityMedium  ctermbg = Yellow
highlight ChorePriorityMedium  ctermfg = Black
highlight ChorePriorityLow     ctermbg = LightGray
highlight ChorePriorityLow     ctermfg = Black
highlight ChorePriorityTrivial ctermbg = Black
highlight ChorePriorityTrivial ctermfg = White

let b:current_syntax = "chore"
