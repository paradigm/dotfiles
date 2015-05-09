" -----------------------------------------------------------------------------
" add a new motion

function! motions#add(keys, func, jump)
	execute "nnoremap <silent> " . a:keys . " :<c-u>call motions#execute('" . a:func . "'," . a:jump .  ", 'n')<cr>"
	execute "onoremap <silent> " . a:keys . " :<c-u>call motions#execute('" . a:func . "'," . a:jump .  ", 'o')<cr>"
	execute "xnoremap <silent> " . a:keys . " :<c-u>call motions#execute('" . a:func . "'," . a:jump .  ", 'v')<cr>"
endfunction

function! motions#execute(func, jump, mode)
	let init_count = v:count1

	" v_: moves cursor, restore it
	if a:mode == 'v'
		normal gv
	endif

	if a:jump
		call support#push_jumplist()
	endif

	for i in range(1, init_count)
		call function(a:func)()
	endfor

	if a:mode == 'v'
		let new_pos = getcurpos()
		normal! gv
		call setpos('.', new_pos)
	endif
endfunction

" -----------------------------------------------------------------------------
" move across region of whitespace or non-whitespace

function! s:parajump(direction)
	let lnum = line('.')
	if col('.') == 1
		let vcol = 1
	elseif getline('.')[col('.')-1] == "\t"
		normal! h
		let vcol = virtcol('.')+1
		normal! l
	else
		let vcol = virtcol('.')
	endif

	" "move" once
	let lnum += a:direction
	let init_w = s:parajump_is_w(lnum, vcol)

	while 1
		" going up, hit top of buffer
		if a:direction == -1 && lnum <= 1
			break
		endif

		" going down, hit buttom of buffer
		if a:direction == 1 && lnum >= line('$')
			break
		endif

		" going over whitespace, stop when hitting non-whitespace
		if init_w && ! s:parajump_is_w(lnum, vcol)
			break
		endif

		" going over non-whitespace, stop just before hitting
		" shorter line
		if ! init_w && s:parajump_is_w(lnum + a:direction, vcol)
			break
		endif

		let lnum += a:direction
	endwhile

	let pos = getcurpos()
	let pos[1] = lnum
	call setpos('.', pos)
	execute 'normal! ' . pos[4] . '|'
endfunction

" returns if character at specified position is over whitespace
function! s:parajump_is_w(lnum, vcol)
	let line = getline(a:lnum)
	if len(line) == 0
		return 1
	elseif strdisplaywidth(line, 0) < a:vcol
		return 1
	else
		while stridx(line, "\t") != -1
			let spaces = repeat(' ', strdisplaywidth("\t", stridx(line, "\t")))
			let line = substitute(line, "\t", spaces, '')
		endwhile
		return line[a:vcol-1] == ' '
	endif
endfunction

function! motions#parajump_down()
	return s:parajump(1)
endfunction

function! motions#parajump_up()
	return s:parajump(-1)
endfunction

" -----------------------------------------------------------------------------
" interactive search for currently visible position

function! motions#viewsearch()
	" pattern for which to search
	let s:pattern = ""
	" matchadd() output for pattern matches
	let s:matchnum = -1
	" matchadd() output for selected index
	let s:matchincnum = -1
	" selected index
	let s:matchidx = 0
	" list of matches (in which to index)
	let s:matches = []
	" initial cursor position
	let s:init_cursor = getcurpos()[1:]

	while 1
		nohlsearch
		let p = s:viewsearch_prompt()
		if p == 0
			return s:viewsearch_abort()
		elseif p == 1 && len(s:matches) != 0
			return s:viewsearch_accept()
		else
			call s:viewsearch_find_matches()
			call s:viewsearch_show_matches()
		endif
	endwhile
endfunction

function! s:viewsearch_prompt()
	redraw
	echo "/" . s:pattern
	let input = getchar()
	if type(input) == 0
		let input = nr2char(input)
	endif
	if input == "\<c-h>" || input == "\<bs>"
		if s:pattern != ""
			let s:pattern = s:pattern[:-2]
		endif
	elseif input == "\<c-u>"
		let s:pattern = ""
	elseif input == "\<c-w>"
		if s:pattern[-1:] == " "
			let s:pattern = s:pattern[:-2]
		endif
		while strlen(s:pattern) > 0 && s:pattern[-1:] != " "
			let s:pattern = s:pattern[:-2]
		endwhile
	elseif input == "\<c-n>"
		let s:matchidx += 1
	elseif input == "\<c-p>"
		let s:matchidx -= 1
	elseif input == "\<esc>"
		" abort
		return 0
	elseif input == "\<cr>"
		" accept
		return 1
	else
		let s:pattern .= input
		let s:matchidx = 0
	endif
	return 2
endfunction

function! s:viewsearch_find_matches()
	let s:matches = []
	if s:pattern == ""
		return
	endif
	" check for match at very beginning
	call cursor(line("w0"), 1)
	silent! let match = searchpos(s:pattern, "Wc", line("w$"))
	if match == [line("w0"), 1]
		let s:matches += [match]
	endif
	" look for other matches
	call cursor(line("w0"), 1)
	while 1
		silent! let match = searchpos(s:pattern, "W", line("w$"))
		if match == [0,0]
			break
		endif
		let s:matches += [match]
	endwhile
	call cursor(s:init_cursor)
endfunction

function! s:viewsearch_show_matches()
	if s:matchnum != -1
		call matchdelete(s:matchnum)
		call matchdelete(s:matchincnum)
	endif
	if len(s:matches) != 0
		" respect 'magic', 'smartcase' and 'ignorecase'
		let l:pattern = ""
		if stridx(s:pattern, '\m') == -1 &&
					\ stridx(s:pattern, '\M') == -1 &&
					\ stridx(s:pattern, '\v') == -1 &&
					\ stridx(s:pattern, '\V') == -1
			if &magic
				let l:pattern .= '\m'
			else
				let l:pattern .= '\M'
			endif
		endif
		if stridx(s:pattern, '\c') == -1 &&
					\ stridx(s:pattern, '\C') == -1
			if &smartcase && s:pattern =~# '[A-Z]'
				let l:pattern .= '\C'
			elseif &ignorecase
				let l:pattern .= '\c'
			else
				let l:pattern .= '\C'
			endif
		endif
		let l:pattern .= s:pattern
		let s:matchnum = matchadd("Search", l:pattern)
		let s:matchincnum = matchadd("ColorColumn", "\\%" . s:matches[s:matchidx % len(s:matches)][0] . "l\\%" . s:matches[s:matchidx % len(s:matches)][1] . "c")
	else
		let s:matchnum = -1
		let s:matchincnum = -1
	endif
endfunction

function! s:viewsearch_accept()
	call s:viewsearch_clean_up()
	let lnum = s:matches[s:matchidx % len(s:matches)][0]
	let col = s:matches[s:matchidx % len(s:matches)][1]
	call cursor(lnum, col)
endfunction

function! s:viewsearch_abort()
	call s:viewsearch_clean_up()
	call cursor(s:init_cursor)
	return
endfunction

function! s:viewsearch_clean_up()
	if s:matchnum != -1
		call matchdelete(s:matchnum)
	endif
	if s:matchincnum != -1
		call matchdelete(s:matchincnum)
	endif
	redraw!
endfunction
