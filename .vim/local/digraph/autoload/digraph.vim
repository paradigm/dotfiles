function! digraph#lookup(...)
	if a:0 == 0 || a:1 == ''
		" use character under cursor
		let char = split(getline('.'),'\zs')[col('.')-1]
	else
		" use specified character
		let char = a:1
	endif

	" using redir to get the same representation as we do redir'ing
	" :digraph, e.g. "^@" is one character in-buffer represented as two
	" characters.
	normal! yl
	redir => repchar
	silent echo char
	redir END
	let c = repchar[1:]

	" get digraphs
	redir => ds
	silent digraphs
	redir END

	" find digraph
	for d in split(ds, '\S\+\s\S\+\s\+\d\+\zs\s\+\ze')
		if split(d)[1] ==# c
			" found digraph
			redraw
			echo split(d)[0]
			return
		endif
	endfor

	redraw
	echo "No digraph found for \"" . c . "\""
endfunction
