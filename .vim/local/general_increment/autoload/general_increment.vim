function! general_increment#increment()
	let pos = getpos(".")
	call search('\<', "bc", line("."))
	for series in g:general_increment_table
		for i in range(0, len(series)-1)
			if search(series[i], 'c', line(".")) != 0
				execute 'normal! cw' . series[(i+1)%len(series)] . "\<esc>b"
				return
			endif
		endfor
	endfor
	call setpos(".", pos)
endfunction
