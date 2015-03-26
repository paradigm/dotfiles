" ==============================================================================
" = awk ftplugin                                                               =
" ==============================================================================

" present working directory
setlocal path=,

" gawk specific
setlocal include=\\v^\\@include\\s*

setlocal define=\\v\\s*function\\s*\\zs\\ze\\i+\\s*\\(

let b:runpath = expand("%:p")

setlocal commentstring=#%s
