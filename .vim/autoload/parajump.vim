" ==============================================================================
" = parajump                                                                   =
" ==============================================================================
"
" Takes in a direction, 'j' or 'k', and returns a command to move the cursor a
" certain distance.  Call via an <expr> map.
"
" If the next move in that direction moves the cursor over whitespace, continue
" moving in the specified direction until the cursor is no longer on
" whitespace.
"
" If the next move in that direction moves the cursor over non-whitespace,
" continue moving in the specified direction until the cursor moves over
" whitespace.

function! parajump#run(direction)
	if a:direction == 'j'
		let delta = 1
	elseif a:direction == 'k'
		let delta = -1
	else
		echohl ErrorMsg
		echo "ParaJump: Illegal direction specified"
		echohl None
		return -1
	endif

	" get starting line number
	let line = line(".")

	" "move" once to start
	let line += delta

	" get starting whitespace/non-whitespace info.
	let inittype = s:CharWhitespace(line)

	while s:CharWhitespace(line) == inittype && line < line("$") && line > 1
		let line += delta
	endwhile

	" purposefully using G here to make a jump break
	return line . "G"
endfunction

" check if the cursor is on whitespace or not
function! s:CharWhitespace(line)
	return stridx(" \t", getline(a:line)[col(".")-1]) != -1
endfunction
