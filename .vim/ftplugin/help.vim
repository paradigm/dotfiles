" ==============================================================================
" = help ftplugin                                                              =
" ==============================================================================

" Use default help tags

" set 'define' to define matches
setlocal define=\\v\\*\\zs\\ze\\k*\\*

if maparg("\<c-]>", "n") != ""
	nunmap <c-]>
endif
