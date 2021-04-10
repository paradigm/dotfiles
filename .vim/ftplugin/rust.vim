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

if executable('rust-analyzer')
	autocmd User lsp_setup call lsp#register_server({
				\   'name': 'Rust Language Server',
				\   'cmd': {server_info->['rust-analyzer']},
				\   'whitelist': ['rust'],
				\ })
endif
