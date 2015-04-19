function! s:get_results(pattern)
	let init_pos = getcurpos()
	let init_bufnr = bufnr("%")
	let results = []
	for b in range(1,bufnr("$"))
		if buflisted(b)
			execute "keepjumps b " . b
			keepjumps normal! gg
			if searchpos(a:pattern, 'Wc') != [0,0]
				let results += [{'bufnr': b, 'lnum': line("."), 'col': col("."), 'text': getline(".")}]
			else
				continue
			endif
			keepjumps normal! gg
			while searchpos(a:pattern, 'W') != [0,0]
				let results += [{'bufnr': b, 'lnum': line("."), 'col': col("."), 'text': getline(".")}]
			endwhile
		endif
	endfor
	execute "keepjumps b " . init_bufnr
	call setpos('.', init_pos)
	return results
endfunction

function! grep_buffers#qflist(pattern)
	silent call setqflist(s:get_results(a:pattern))
	call support#cc()
endfunction

function! grep_buffers#loclist(pattern)
	silent call setloclist(winnr(),s:get_results(a:pattern))
	call support#ll()
endfunction
