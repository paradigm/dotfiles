" ==============================================================================
" = cconerror                                                                  =
" ==============================================================================

" run after attempting to populate quickfixlist
" if quickfix has something, jump to first item

function! cconerror#run()
	for error in getqflist()
		if error['bufnr'] != 0
			cc
			return
		endif
	endfor
	redraw
	echo 'no errors/results'
endfunction
