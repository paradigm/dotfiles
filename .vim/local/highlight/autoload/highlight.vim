let g:highlight_ids = []

function! highlight#add_cmdline_completion(A,L,P)
	if len(split(a:L)) > 2 || (len(split(a:L)) == 2 && a:L[-1:] =~ '\s')
		return []
	endif
	let regex = support#glob2regex(a:A)
	let results = []
	for color in g:highlight_colors
		if color[0] =~ regex
			let results += [color[0]]
		endif
	endfor
	return results
endfunction

function! highlight#remove_cmdline_completion(A,L,P)
	echo a:P | call getchar()
	let regex = substitute(a:A, '\\ ', ' ', 'g')
	let regex = support#glob2regex(a:A)
	let patterns = []
	for match in map(getmatches(), 'v:val["pattern"]')
		let patterns += [escape(match, ' ')]
	endfor
	return patterns
endfunction

function! highlight#add(args)
	if len(split(a:args)) < 2
		echohl ErrorMsg
		echo "Highlight: Insufficient arguments"
		echohl Normal
		return
	endif

	let color = split(a:args)[0]
	let pattern = substitute(a:args, '^\s*\S\+\s*','','')

	let i = index(map(copy(g:highlight_colors), 'v:val[0]'), color)
	if i == -1
		echohl ErrorMsg
		echo "Highlight: unrecognized color provided"
		echohl Normal
		return
	endif

	try
		execute 'silent highlight Highlight_' . color
	catch
		execute 'highlight Highlight_' . color . ' ctermfg=' . g:highlight_colors[i][1] . ' ctermbg=' . g:highlight_colors[i][2]
	endtry

	let g:highlight_ids += [matchadd('Highlight_' . color, pattern)]
endfunction

function! highlight#remove(...)
	let pattern=join(a:000)

	let found = 0
	for match in getmatches()
		if match["pattern"] =~ pattern
			" found a matchadd() entry which matches
			" cursor position
			for i in range(len(g:highlight_ids)-1, 0, -1)
				if g:highlight_ids[i] == match["id"]
					call remove(g:highlight_ids, i)
					break
				endif
			endfor
			call matchdelete(match["id"])
			" note that we found something
			let found = 1
		endif
	endfor

	if !found
		echohl ErrorMsg
		echo "Highlight: unrecognized pattern provided"
		echohl Normal
	endif
endfunction

function! highlight#undo()
	if g:highlight_ids != []
		call matchdelete(g:highlight_ids[-1])
		let g:highlight_ids = g:highlight_ids[:-2]
	else
		echohl ErrorMsg
		echo "Highlight: no more highlights to undo"
		echohl Normal
	endif
endfunction

function! highlight#remove_all()
	if len(g:highlight_ids) == 0
		return
	endif
	for i in range(len(g:highlight_ids)-1, 0, -1)
		call matchdelete(g:highlight_ids[i])
		call remove(g:highlight_ids, i)
	endfor
endfunction

function! highlight#remove_cursor()
	" backup cursor position
	let init_cursor = getcurpos()

	let found = 0
	" iterate through all matchadd() values
	for match in getmatches()
		" ensure match is highlight-specific
		let check = 0
		for id in g:highlight_ids
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
				" cursor position
				for i in range(len(g:highlight_ids)-1, 0, -1)
					if g:highlight_ids[i] == match["id"]
						call remove(g:highlight_ids, i)
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

function! highlight#operator(type, color)
	let pattern = operators#get_range_content(a:type)

	for line in split(pattern, "\n")
		if line == ''
			continue
		endif
		" de-regex
		let line = '\V' . escape(line, '/\')
		" matchadd() doesn't like real newlines
		let line = substitute(line, "\n", '\\n', "g")
		execute 'HighlightAdd ' . a:color . ' ' . line
	endfor
endfunction

