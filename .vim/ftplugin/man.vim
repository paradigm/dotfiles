" ==============================================================================
" = man ftplugin                                                               =
" ==============================================================================

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
