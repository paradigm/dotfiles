function! digraph_lookup#undercursor()
	" get character under cursor
	"
	" using redir here so we get the same representation as we do
	" redir'ing :digraph, e.g. "^@" is one character in-buffer represented
	" as two characters.
	let unnamedreg = @"
	normal! yl
	redir => c
	silent echo @"
	redir END
	let @" = unnamedreg
	let c = c[1:]

	" get digraphs
	redir => ds
	silent digraphs
	redir END

	" find digraph
	for d in split(ds, '\S\+\s\S\+\s\+\d\+\zs\s\+\ze')
		if split(d)[1] == c
			" found digraph
			redraw
			echo split(d)[0]
			return
		endif
 	endfor

	redraw
	echo "No digraph found for \"" . c . "\""
endfunction
