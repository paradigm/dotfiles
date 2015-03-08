" ==============================================================================
" = highlight                                                                  =
" ==============================================================================

if !exists("s:ids")
	let s:ids = []
endif

function! highlight#add(...)
	if a:0 < 2
		echohl ErrorMsg
		echo "Highlight: Insufficient arguments"
		echohl Normal
		return
	endif

	try
		execute "silent highlight Highlight" . a:1
	catch
		echohl ErrorMsg
		echo "Highlight: unrecognized color provided"
		echohl Normal
		return
	endtry

	let pattern = join(a:000[1:])

	call s:add("Highlight" . a:1, pattern)
endfunction

function! highlight#remove(...)
	let pattern=join(a:000)

	for match in getmatches()
		if match["pattern"] =~ pattern
			" found a matchadd() entry which matches
			" cursor position - remove it from s:ids
			for i in range(len(s:ids)-1, 0, -1)
				if s:ids[i] == match["id"]
					call remove(s:ids, i)
					break
				endif
			endfor
			call matchdelete(match["id"])
			" note that we found something
			let found = 1
		endif
	endfor
endfunction

function! highlight#undo()
	if s:ids != []
		call matchdelete(s:ids[-1])
		let s:ids = s:ids[:-2]
	else
		echohl ErrorMsg
		echo "Highlight: no more highlights to undo"
		echohl Normal
	endif
endfunction

function! highlight#remove_all()
	if len(s:ids) == 0
		return
	endif
	for i in range(len(s:ids)-1, 0, -1)
		call matchdelete(s:ids[i])
		call remove(s:ids, i)
	endfor
endfunction

function! highlight#remove_under_cursor()
	" backup cursor position
	let init_cursor = getcurpos()

	let found = 0
	" iterate through all matchadd() values
	for match in getmatches()
		" ensure match is highlight-specific
		let check = 0
		for id in s:ids
			if match["id"] == id
				let check = 1
			endif
		endfor
		if !check
			continue
		endif

		" check every match in the buffer
		let first_round = 1
		call setpos(".", [0, 1, 1, 0])
		while 1
			if first_round
				let start = searchpos('\zs' . match["pattern"], 'Wc')
				let end = searchpos(match["pattern"] . '\zs', 'Wc')
				let first_round = 0
			else
				let start = searchpos('\zs' . match["pattern"], 'W')
				let end = searchpos(match["pattern"] . '\zs', 'W')
			endif

			if start == [0,0] || end == [0,0]
				break
			endif
			if line(start) < init_cursor[1] || (line(start) == init_cursor[1] && col(start) <= init_cursor[2])
				let start_good = 1
			else
				let start_good = 0
			endif
			if line(end) > init_cursor[1] || (line(end) == init_cursor[1] && col(end) >= init_cursor[2])
				let end_good = 1
			else
				let end_good = 0
			endif
			if start_good && end_good
				" found a matchadd() entry which matches
				" cursor position - remove it from s:ids
				for i in range(len(s:ids)-1, 0, -1)
					if s:ids[i] == match["id"]
						call remove(s:ids, i)
						break
					endif
				endfor
				call matchdelete(match["id"])
				" note that we found something
				let found = 1
			endif
		endwhile
	endfor

	" warn user if we never found anything
	if !found
		echohl ErrorMsg
		echo "Highlight: No highlight under cursor to remove"
		echohl Normal
	endif

	" restore cursor position
	call setpos(".", init_cursor)
endfunction

function! highlight#complete_add(A,L,P)
	if len(split(a:L)) > 2 || (len(split(a:L)) == 2 && a:L[-1:] =~ '\s')
		return []
	endif
	let regex = glob2regex#conv(a:A)
	let results = []
	for color in g:highlight_colors
		if color[0] =~ regex
			let results += [color[0]]
		endif
	endfor
	return results
endfunction

function! highlight#complete_remove(A,L,P)
	let regex = substitute(a:A, '\\ ', ' ', 'g')
	let regex = glob2regex#conv(regex)
	let patterns = []
	for match in getmatches()
		let patterns += [escape(match["pattern"], ' ')]
	endfor
	return patterns
endfunction

function! highlight#range(type, color)
	let pattern = custom_operators#get_range_content(a:type)

	if a:type == "block" || a:type == "\<c-v>"
		for line in split(pattern, "\n")
			" de-regex
			let line = '\V' . escape(line, '/\')
			" matchadd() doesn't like real newlines
			let line = substitute(line, "\n", '\\n', "g")
			call s:add(a:color, line)
		endfor
	else
		" de-regex
		let pattern = '\V' . escape(pattern, '/\')
		" matchadd() doesn't like real newlines
		let pattern = substitute(pattern, "\n", '\\n', "g")
		" add
		call s:add(a:color, pattern)
	endif

endfunction

function! s:add(color, pattern)
	let s:ids += [matchadd(a:color, a:pattern)]
endfunction
