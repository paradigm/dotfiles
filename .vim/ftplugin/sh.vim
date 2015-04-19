" ==============================================================================
" = sh ftplugin                                                                =
" ==============================================================================

" enable if/do/for folding
let g:sh_fold_enabled=4

" have [i and friends follow . and source
setlocal include=^\\s*\\<\\(source\\\|[.]\\)\\>

" Due to newline matching, does not work with built-in 'define' functionality;
" requires specialized versions.
setlocal define=\\v(^\|;)\\s*(\\zs\\ze\\i+\\s*\\(\\s*\\)\|(function\\_s*\\zs\\ze\\i+))\\_s*\\{

nnoremap <silent> <buffer> K :<c-u>call preview#man(expand("<cword>"), '')<cr>

let b:runpath = expand("%:p")

setlocal path+=,

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
