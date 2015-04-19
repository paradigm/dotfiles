" ==============================================================================
" = git ftplugin                                                               =
" ==============================================================================

" have 'define' match commit hashes
setlocal define=^\\vcommit\ \\zs\\ze[0-9a-f]+

" if fugitive is available...
if exists('g:loaded_fugitive')
	" have <c-]> over a git hash/tag/etc do a "git show" on it
	nnoremap <c-]> "*yiw:call support#push_stack()<cr>:Git! show <c-r>*<cr>
	" pop tag stack
	nnoremap <buffer> <c-t> :call support#pop_stack()<cr>
endif
