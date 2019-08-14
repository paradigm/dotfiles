" ==============================================================================
" = git ftplugin                                                               =
" ==============================================================================

" remove formatting information in favor of vim's
silent! %s/[^m]*m//g
1

" have 'define' match commit hashes
setlocal define=^\\vcommit\ \\zs\\ze[0-9a-f]+

" Do not try to syntax highlight overly long git logs
if line("$") > 10000
	setlocal syntax=off
endif

" if fugitive is available...
if exists('g:loaded_fugitive')
	" have <c-]> over a git hash/tag/etc do a "git show" on it
	nnoremap <buffer> <c-]> "*yiw:call support#push_stack()<cr>:Git! show <c-r>*<cr>
	" pop tag stack
	nnoremap <buffer> <c-t> :call support#pop_stack()<cr>
endif
