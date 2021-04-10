" ==============================================================================
" = vim_ftplugin                                                               =
" ==============================================================================

" have [i and friends follow :source and relevant rtp entries
setlocal include=^\\s*\\(set\\s\\+\\(rtp\\\|runtimepath\\)+=\\\|source\\)
setlocal includeexpr=IncludeExprVim()
function! IncludeExprVim()
	if !isdirectory(expand(v:fname))
		return v:fname
	else
		let expanded_source_file = tempname()
		let source_lines = map(split(globpath(v:fname . "/plugin/," . v:fname . "/autoload/", "**/*.vim"), '\n'), '"source " . v:val')
		call writefile(source_lines, expanded_source_file)
		return expanded_source_file
	endif
endfunction

setlocal path=
for rtp in split(&rtp, ',')
	execute 'setlocal path+=' . rtp . '/plugin'
	execute 'setlocal path+=' . rtp . '/autoload'
endfor

setlocal define=\\v^\\s*fu%[nction]!?\\s+\\zs\\ze\\i+\\(

function! Text_Obj_Around_vim_func()
	call search(&define, 'bcW')
	normal! V
	call search('^endf', 'W')
endfunction
let b:sel_a_func="Text_Obj_Around_vim_func"

function! Text_Obj_Inside_vim_func()
	call search(&define, 'bcW')
	normal! 0jV
	call search('^endf', 'W')
	normal! k
endfunction
let b:sel_i_func="Text_Obj_Inside_vim_func"

" open help page for word under cursor in preview window
nnoremap <buffer> K :execute 'H ' . expand("<cword>")<cr>

" Vim has its own omnicompletion mapping by default, separate from the normal
" one. Set the normal omnicompletion mapping to cover the special VimL
" completion, as well as the custom ctrl-space.
inoremap <buffer> <c-x><c-o> <c-x><c-v>
inoremap <buffer> <c-@> <c-x><c-v>

" Remove the "=" and "," characters from consideration for a file path when
" using things such as `gf`.  This is useful to follow file paths provided to
" Vim variables and settings.
setlocal isfname -==
setlocal isfname -=,

" Include "#" and ":" in identifiers, as its used in some vim function names
setlocal isident +=#
setlocal isident +=:

if executable('vim-language-server')
	autocmd User lsp_setup call lsp#register_server({
				\   'name': 'vim-language-server',
				\   'cmd': {server_info->['vim-language-server', '--stdio']},
				\   'whitelist': ['vim'],
				\ })
endif
