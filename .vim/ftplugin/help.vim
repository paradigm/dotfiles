" ==============================================================================
" = help ftplugin                                                              =
" ==============================================================================

" Use default help tags

" set 'define' to get help tag results
setlocal define=\\v\\*\\zs\\ze\\k*\\*

" use default ctrl-]
if maparg("\<c-]>", "n") != ""
	nunmap <buffer> <c-]>
endif
