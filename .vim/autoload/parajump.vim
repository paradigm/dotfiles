" ==============================================================================
" = parajump                                                                   =
" ==============================================================================
"
" If the next move in that direction (1 for down, -1 for up) moves the cursor
" over whitespace, continue moving in the specified direction until the cursor
" is no longer on whitespace.
"
" If the next move in that direction moves the cursor over non-whitespace,
" continue moving in the specified direction until the cursor moves over
" whitespace.

function! parajump#run(direction)
	return s:main(a:direction, 0)
endfunction

function! parajump#expr(direction)
	return s:main(a:direction, 1)
endfunction

function! s:main(direction, expr)
	" get starting line number
	let line = line(".")

	" "move" once to start
	let line += a:direction

	" get starting whitespace/non-whitespace info.
	let inittype = s:CharWhitespace(line)

	while s:CharWhitespace(line) == inittype && line < line("$") && line > 1
		let line += a:direction
	endwhile

	" purposefully using G here to make a jump break
	if a:expr
		return line . "G"
	else
		execute "normal " . line . "G"
		return
	endif
endfunction

" check if the cursor is on whitespace or not
function! s:CharWhitespace(line)
	return stridx(" \t", getline(a:line)[col(".")-1]) != -1
endfunction
