" ==============================================================================
" = man ftplugin                                                               =
" ==============================================================================

" remove formatting information in favor of vim's
silent! %s/.//g
1

" section headers
setlocal define=\\v^\\zs\\ze[A-Z-\ ]+$

" man sets the content width to the window width.  The number column ends up
" making everything offset a bit.
setlocal nonumber
if exists('&relativenumber')
	set norelativenumber
endif

" if this vim has 'showbreak', use it
if exists('&breakindent')
	setlocal breakindent
endif
