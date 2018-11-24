" ==============================================================================
" = rust ftplugin                                                              =
" ==============================================================================

setlocal define=\\<fn\\>\\s\\+\\zs\\i\\+\\ze\\s*(

setlocal formatprg=rustfmt

setlocal makeprg=cargo\ build

let b:runcmd='cargo run'

function! Text_Obj_Around_rust_func()
	call search(&define, 'bcW')
	call search('{', 'W')
	normal! %V
	call search(&define, 'bW')
endfunction
let b:sel_a_func="Text_Obj_Around_rust_func"

function! Text_Obj_Inside_rust_func()
	call search(&define, 'bcW')
	call search('{', 'W')
	normal! V%koj
endfunction
let b:sel_i_func="Text_Obj_Inside_rust_func"

if exists('g:loaded_racer')
	" remove problematic autocmds created by plugins
	autocmd! Filetype rust

	" jump to defintion
	" note g<c-]> is still available to access tag jump
	nnoremap <buffer> <c-]> :call support#push_stack()<cr>:call RacerGoToDefinition()<cr>
	" pop tag stack
	nnoremap <buffer> <c-t>        :call support#pop_stack()<cr>
	nnoremap <buffer> <space>P :call preview#jump('call RacerGoToDefinition()', '')<cr>
	nnoremap <buffer> <space><c-p> :call preview#jump('call RacerGoToDefinition()', 1)<cr>

	setlocal omnifunc=RacerComplete
endif
