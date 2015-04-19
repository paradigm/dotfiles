function! preview#shell(cmd, bang)
	if a:bang
		redraw
		echo split(system(a:cmd), "\n")[0]
	else
		execute "pedit! " . tempname()
		wincmd P
		setlocal buftype=nofile
		setlocal bufhidden=delete
		setlocal nobuflisted
		setlocal noswapfile

		let filename = substitute(a:cmd, ' ', '_', 'g')
		let filename = substitute(filename, '[|"]', '\\&', 'g')
		execute "silent! file shell_out:" . filename

		call append(1, split(system(a:cmd), "\n"))
		1d _
	endif
endfunction

function! preview#man(word, bang)
	let cmd = "man "
	let cmd .= (v:count > 0 ? v:count : "") . " "
	let cmd .= a:word
	let cmd .= ' | col -b'
	call preview#shell(cmd, a:bang)
	if !a:bang
		set ft=man
	endif
endfunction

function! preview#jump(cmd, bang)
	let win = winsaveview()
	let pos = getcurpos()
	let buf = bufnr("%")
	execute "keepalt keepjumps silent! " . a:cmd
	if pos == getcurpos() && buf == bufnr("%")
		echohl ErrorMsg |
		echo "E387: Match is on current line"
		echohl Normal
		return
	endif
	let previewline = getline(".")
	let previewpos = getcurpos()
	let previewbuf = bufnr("%")

	execute "keepalt keepjumps silent! buf " . buf
	keepjumps call setpos(".", pos)
	call winrestview(win)

	if a:bang
		redraw
		echo previewline
	else
		execute "pedit! " . bufname(previewbuf)
		wincmd P
		call setpos(".", previewpos)
		wincmd w
	endif
endfunction

function! preview#cmd(cmd, bang)
	let unnamedreg = @"

	redir @"
	execute "silent! " . a:cmd
	redir END

	if a:bang
		redraw
		echo split(@", "\n")[0]
	else
		execute "pedit! " . tempname()
		wincmd P
		setlocal buftype=nofile
		setlocal bufhidden=delete
		setlocal nobuflisted
		setlocal noswapfile

		call append(1, split(@", "\n"))
		1d _
	endif

	let @" = unnamedreg
endfunction
