" ==============================================================================
" = quickfixsigns                                                              =
" ==============================================================================

" populate the sign column based on quickfix results
function! quickfixsigns#run()
	sign define warning text=WW texthl=Error
	sign define error text=EE texthl=Error
	sign define convention text=CC texthl=Error
	sign define misc text=>> texthl=Error
	sign unplace *
	let qflines = []
	for item in getqflist()
		if item['bufnr'] != 0
			if item['text'][0] == 'E' || item['text'][1] == 'E'
				execute "sign place 1 line=" . item['lnum'] . " name=error buffer=" . item['bufnr']
			elseif item['text'][0] == 'W' || item['text'][1] == 'W'
				execute "sign place 1 line=" . item['lnum'] . " name=warning buffer=" . item['bufnr']
			elseif item['text'][0] == 'W' || item['text'][1] == 'C'
				execute "sign place 1 line=" . item['lnum'] . " name=convention buffer=" . item['bufnr']
			else
				execute "sign place 1 line=" . item['lnum'] . " name=misc buffer=" . item['bufnr']
			endif
		endif
	endfor
endfunction
