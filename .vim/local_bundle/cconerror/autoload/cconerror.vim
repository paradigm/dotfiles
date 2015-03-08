" ==============================================================================
" = cconerror                                                                  =
" ==============================================================================

" run after attempting to populate quickfixlist
" if quickfix has something, jump to first item

function! cconerror#qf()
	call s:cconerror(getqflist())
endfunction

function! cconerror#loc()
	call s:cconerror(getloclist(0))
endfunction

function! s:cconerror(list)
	for error in a:list
		if error['bufnr'] != 0
			cc
			return
		endif
	endfor
	redraw
	echo 'no errors/results'
endfunction
