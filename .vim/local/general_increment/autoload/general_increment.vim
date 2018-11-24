function! general_increment#next(direction)
	let pos = getpos(".")
	call search('\<', "bc", line("."))
	for series in g:general_increment_table
		for i in range(0, len(series)-1)
			if search(series[i], 'c', line(".")) != 0
				let next_i = (i + (a:direction * v:count1)) % len(series)
				if next_i == -1
					let next_i = len(series)-1
				endif
				let next = series[next_i]
				if expand("<cword>")[0] =~ '\C[A-Z]'
					let next = toupper(next[0]) . next[1:]
				endif
				if expand("<cword>")[1] =~ '\C[A-Z]'
					let next = toupper(next)
				endif
				execute 'normal! cw' . next . "\<esc>b"
				return
			endif
		endfor
	endfor
	call setpos(".", pos)
endfunction
