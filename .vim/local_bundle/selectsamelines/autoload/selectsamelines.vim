" ==============================================================================
" = selectsamelines                                                            =
" ==============================================================================

" Select region with neighboring lines that contain same character in same
" column as cursor
function! selectsamelines#run(select_cmd)
	let l:start_line = line(".")
	let l:end_line = line(".")
	let l:start_col = col(".")-1
	let l:char = getline(".")[l:start_col]
	" search backwards for start"
	while l:start_line != 1 && getline(l:start_line-1)[l:start_col] == l:char
		let l:start_line -= 1
	endwhile
	while l:start_line != line("$") && getline(l:end_line+1)[l:start_col] == l:char
		let l:end_line += 1
	endwhile
	let pos = getpos(".")
	let pos[1] = start_line
	call setpos(".", pos)
	execute "normal! " . a:select_cmd . (end_line - start_line) . "\<down>"
endfunction
