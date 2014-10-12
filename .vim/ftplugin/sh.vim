" ==============================================================================
" = sh ftplugin                                                                =
" ==============================================================================

" enable if/do/for folding
let g:sh_fold_enabled=4

" Syntax highlight embedded awk.  Taken from syntax.txt, which took it from
" Aaron Hope's aspperl.vim
if exists("b:current_syntax")
  unlet b:current_syntax
endif
syn include @AWKScript syntax/awk.vim
syn region AWKScriptCode matchgroup=AWKCommand start=+[=\\]\@<!'+ skip=+\\'+ end=+'+ contains=@AWKScript contained
syn region AWKScriptEmbedded matchgroup=AWKCommand start=+\<awk\>+ skip=+\\$+ end=+[=\\]\@<!'+me=e-1 contains=@shIdList,@shExprList2 nextgroup=AWKScriptCode
syn cluster shCommandSubList add=AWKScriptEmbedded
hi def link AWKCommand Type

" Open man page for word under cursor in preview window.  Can prefix a count
" to do which mount number, e.g.: 2K will open "man 2 <cword>"
nnoremap <buffer> K :<c-u>call preview#shell("man " . (v:count > 0 ? v:count : "") . " " . expand("<cword>"))<cr>
