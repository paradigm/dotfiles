" ==============================================================================
" = grepbuffers                                                                =
" ==============================================================================
"
" grep through open buffers instead of files

function! grepbuffers#run(arg)
	let initbufnr = bufnr("%")
	call setqflist([])
	for b in range(1,bufnr("$"))
		if buflisted(b)
			execute "keepjumps b " . b
			keepjumps normal gg
			while searchpos(a:arg, 'W') != [0,0]
				call setqflist([{'bufnr': b, 'lnum': line("."), 'col': col("."), 'text': getline(".")}], 'a')
			endwhile
		endif
	endfor
	execute "keepjumps b " . initbufnr
	call cconerror#qf()
endfunction
