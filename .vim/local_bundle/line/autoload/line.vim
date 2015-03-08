" ==============================================================================
" = line                                                                       =
" ==============================================================================
"
" Jump to line with contents described via argument.  Intended to be used via
" SkyBison, but should technically work without it.

function! line#list(A,L,P)
	if a:A == ""
		return []
	endif
	let regex = substitute(a:A, '\\ ', ' ', 'g')
	let regex = glob2regex#conv(regex)
	let lines = []
	for i in range(1,line("$"))
		if getline(i) =~ regex
			let lines += [escape(getline(i), ' ')]
		endif
	endfor
	return lines
endfunction

function! line#run(pattern)
	let regex = substitute(a:pattern, '\\ ', ' ', 'g')
	let regex = glob2regex#conv(regex)
	if s:match_count(regex) > 1 && s:match_count("^" . regex) == 1
		let regex = "^" . regex
	endif
	let @/ = regex
	execute "normal! /" . @/ . "\<cr>"
	return
endfunction

" returns 0 or 1 or 2 - anything higher than 2 is returned as 2.
function! s:match_count(regex)
	let s:init_cursor = getcurpos()[1:]
	let c = 0
	call cursor(1, 1)
	while c < 2
		silent! let match = searchpos(a:regex, "W")
		if match == [0,0]
			break
		endif
		let c += 1
	endwhile
	call cursor(s:init_cursor)
	return c
endfunction
