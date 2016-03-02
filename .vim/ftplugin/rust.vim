" ==============================================================================
" = rust ftplugin                                                              =
" ==============================================================================

setlocal define=\\<fn\\>\\s\\+\\zs\\i\\+\\ze\\s*(

setlocal formatprg=rustfmt

setlocal makeprg=cargo\ build

let b:runcmd='cargo run'

let b:sel_i_func="normal! :call search(&define, 'bW')\<cr>" .
			\ ":call search('{', 'W')\<cr>" .
			\ "V%koj"

let b:sel_a_func="normal! :call search(&define, 'bW')\<cr>" .
			\ ":call search('{', 'W')\<cr>" .
			\ "%v" .
			\ ":\<c-u>call search(&define, 'bW')\<cr>" .
			\ "0v`>o"

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
