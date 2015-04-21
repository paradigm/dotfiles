function! grep#settings(grepprg, grepformat, bang, loc, ...)
	if a:0 == 0
		echohl ErrorMsg
		echo "E471: Argument required"
		echohl Normal
	elseif a:0 == 1
		let files = '**/*'
	elseif a:2[-1] == '/'
		let files = a:2 . '**/*'
	else
		let files = a:2
	endif

	let init_grepprg=&l:grepprg
	let init_grepformat=&l:grepformat

	let &l:grepprg = a:grepprg
	let &l:grepformat = a:grepformat

	execute 'silent ' . a:loc . 'grep' . a:bang . ' ' . a:1 . ' ' . files | redraw!

	let &l:grepprg = init_grepprg
	let &l:grepformat = init_grepformat

	if a:loc == 'l'
		call support#ll()
	else
		call support#cc()
	endif
endfunction

function! grep#buffers(pattern, loc)
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
	if a:loc == 'l'
		silent call setloclist(winnr(),s:get_results(a:pattern))
		call support#ll()
	else
		silent call setqflist(s:get_results(a:pattern))
		call support#cc()
	endif
endfunction
