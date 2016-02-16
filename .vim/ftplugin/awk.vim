" ==============================================================================
" = awk ftplugin                                                               =
" ==============================================================================

" present working directory
setlocal path=,

" gawk specific
setlocal include=\\v^\\@include\\s*

setlocal define=\\v\\s*function\\s*\\zs\\ze\\i+\\s*\\(

let b:sel_i_func="normal! :call search(&define, 'bW')\<cr>" .
			\ ":call search('{', 'W')\<cr>" .
			\ "V%koj"

let b:sel_a_func="normal! :call search(&define, 'bW')\<cr>" .
			\ ":call search('{', 'W')\<cr>" .
			\ "%v" .
			\ ":\<c-u>call search(&define, 'bW')\<cr>" .
			\ "0v`>o"

let b:runpath = expand("%:p")

setlocal commentstring=#%s
