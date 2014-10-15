" ==============================================================================
" = whilepos                                                                   =
" ==============================================================================

" Repeats the provided command so long as function-specified condition holds
" until argument-specified condition occurs
" These are useful to find first or last instance of something

" Keep running command so long as cursor moves in specified dimension.
function! whilepos#change(cmd, bufnum, lnum, col, off)
	let pos = [-1,-1,-1,-1]
	while 1
		execute "normal " . a:cmd
		if a:bufnum && pos[0] != bufnr("%")
			let pos = getpos(".")
			let pos[0] = bufnr("%")
			continue
		endif
		if a:lnum && pos[1] != getpos(".")[1]
			let pos = getpos(".")
			let pos[0] = bufnr("%")
			continue
		endif
		if a:col && pos[2] != getpos(".")[2]
			let pos = getpos(".")
			let pos[0] = bufnr("%")
			continue
		endif
		if a:off && pos[3] != getpos(".")[3]
			let pos = getpos(".")
			let pos[0] = bufnr("%")
			continue
		endif
		break
	endwhile
endfunction

" Keep running command so long as cursor moves in some dimension other than
" specified dimension.
function! whilepos#same(cmd, bufnum, lnum, col, off)
	let pos = getpos(".")
	let pos[0] = bufnr("%")
	while 1
		execute "normal! " . a:cmd
		if pos[0] == bufnr("%") && pos[1:] == getpos(".")[1:]
			break
		endif
		if a:bufnum && pos[0] == bufnr("%")
			let pos = getpos(".")
			let pos[0] = bufnr("%")
			continue
		endif
		if a:lnum && pos[1] == getpos(".")[1]
			let pos = getpos(".")
			let pos[0] = bufnr("%")
			continue
		endif
		if a:col && pos[2] == getpos(".")[2]
			let pos = getpos(".")
			let pos[0] = bufnr("%")
			continue
		endif
		if a:off && pos[3] == getpos(".")[3]
			let pos = getpos(".")
			let pos[0] = bufnr("%")
			continue
		endif
		break
	endwhile
endfunction
