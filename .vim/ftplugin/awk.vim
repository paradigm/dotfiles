" ==============================================================================
" = awk ftplugin                                                               =
" ==============================================================================

" present working directory
setlocal path=,

" gawk specific
setlocal include=\\v^\\@include\\s*

setlocal define=\\v\\s*function\\s*\\zs\\ze\\i+\\s*\\(

function! Text_Obj_Around_awk_func()
	call search(&define, 'bcW')
	call search('{', 'W')
	normal! %V
	call search(&define, 'bW')
endfunction
let b:sel_a_func="Text_Obj_Around_awk_func"

function! Text_Obj_Inside_awk_func()
	call search(&define, 'bcW')
	call search('{', 'W')
	normal! V%koj
endfunction
let b:sel_i_func="Text_Obj_Inside_awk_func"

let b:runpath = expand("%:p")

setlocal commentstring=#%s
