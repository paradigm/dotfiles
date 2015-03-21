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

function! parajump#n(direction)
	return s:main(a:direction, "")
endfunction

function! parajump#v(direction)
	return s:main(a:direction, "gv")
endfunction

function! s:main(direction, visual)
	" get starting line number
	let line = line(".")

	" "move" once to start
	let line += a:direction

	" if the starting line is empty, assume whitespace.  Otherwise, get
	" starting whitespace/non-whitespace state.
	if getline(line) == ""
		let inittype = 1
	else
		let inittype = s:CharWhitespace(getline(line), virtcol("."))
	endif

	" find change
	while (s:CharWhitespace(getline(line), virtcol(".")) == inittype || getline(line) == "") && line < line("$") && line > 1
		let line += a:direction
	endwhile

	" go to desired line, retaining column
	"
	" purposefully using G here to make a jump break
	execute "normal! " . a:visual . line . "G" . virtcol(".") . "|"
	return
endfunction

" figure out whether whitespace will be under the cursor if it is moved to the
" given line
function! s:CharWhitespace(line, col)
	" make scratch buffer to apply retab to
	new|setlocal buftype=nofile bufhidden=delete noswapfile expandtab
	call setline(1, a:line)
	retab

	" get the length of the retab'd line and the char under the cursor
	let len = strlen(getline(1))
	let char = getline(1)[a:col-1]

	" close scratch window
	noautocmd q

	if len < a:col
		return 0
	else
		return char == " "
	endif
endfunction
