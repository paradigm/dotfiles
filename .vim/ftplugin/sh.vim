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

setlocal isident +=-

function! Text_Obj_Around_sh_func()
	call search(&define, 'bcW')
	call search('{', 'W')
	normal! %V
	call search(&define, 'bcW')
endfunction
let b:sel_a_func="Text_Obj_Around_sh_func"

function! Text_Obj_Inside_sh_func()
	call search(&define, 'bW')
	call search('{', 'W')
	normal! V%koj
endfunction
let b:sel_i_func="Text_Obj_Inside_sh_func"

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

if executable('bash-language-server')
	let lsp_format_on_save=1
	autocmd User lsp_setup call lsp#register_server({
				\   'name': 'Bash Language Server',
				\   'cmd': {server_info->['bash-language-server', 'start']},
				\   'whitelist': ['sh', 'bash', 'zsh'],
				\ })
endif
