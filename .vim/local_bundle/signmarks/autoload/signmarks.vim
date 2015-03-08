" ==============================================================================
" = sigmmarks                                                                  =
" ==============================================================================

" show marks in sign column
function! signmarks#run()
	sign unplace *
	for mark in split("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789[]<>'\"^.`(){}",'\zs')
		let char = mark
		let pos = getpos("'" . char)
		if pos != [0,0,0,0]
			if pos[0] != 0
				let bufnr = pos[0]
			else
				let bufnr = bufnr("%")
			endif
			execute "sign define mark" . char . " text='" . char . " texthl=NonText"
			execute "sign place 1 line=" . pos[1] . " name=mark" . char . " buffer=" . bufnr
		endif
	endfor
endfunction
