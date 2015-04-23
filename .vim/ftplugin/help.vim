" ==============================================================================
" = help ftplugin                                                              =
" ==============================================================================

" Use default help tags

" set 'define' to get help tag results
setlocal define=\\v\\*\\zs\\ze\\k*\\*

" use default ctrl-]
if maparg("\<c-]>", "n") != ""
	nnoremap <buffer> <c-]> <c-]>
endif

setlocal nolist

setlocal iskeyword=!-~,^*,^\|,^\",192-255

nnoremap <buffer> K :execute 'H ' . expand("<cword>")<cr>
