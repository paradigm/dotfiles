" ==============================================================================
" = viewsearch                                                                 =
" ==============================================================================
"
" - prompts user for a search pattern
" - highlights all matching results in the current window
" - user can cycle through focused result via ctrl-n/p
" - user can accept to jump to result with <cr> or abort with <esc>

function! viewsearch#run()
	let s:expr = 0
	return s:main()
endfunction

function! viewsearch#expr()
	let s:expr = 1
	return s:main()
endfunction

function! s:main()
	call s:init()
	while 1
		let p = s:prompt()
		if p == 0
			return s:abort()
		elseif p == 1 && len(s:matches) != 0
			return s:accept()
		else
			call s:find_matches()
			call s:show_matches()
		endif
	endwhile
endfunction

function! s:accept()
	call s:clean_up()
	let line = s:matches[s:matchidx % len(s:matches)][0]
	let col = s:matches[s:matchidx % len(s:matches)][1]
	if s:expr
		return line . "G" .  col . "|"
	else
		" go to result and add to jumplist
		execute "keeppatterns normal! /\\%" . line . "l\\%" . col . "c\<cr>"
		return 1
	endif
endfunction

function! s:abort()
	call s:clean_up()
	call cursor(s:init_cursor)
	if s:expr
		return ""
	else
		return 0
	endif
endfunction

function! s:init()
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
endfunction

function! s:clean_up()
	if s:matchnum != -1
		call matchdelete(s:matchnum)
	endif
	if s:matchincnum != -1
		call matchdelete(s:matchincnum)
	endif
	redraw!
endfunction

function! s:prompt()
	redraw
	echo "/" . s:pattern
	let input = getchar()
	if type(l:input) == 0
		let l:input = nr2char(l:input)
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

function! s:find_matches()
	let s:matches = []
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

function! s:show_matches()
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
