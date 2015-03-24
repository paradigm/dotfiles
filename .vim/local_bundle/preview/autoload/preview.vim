" ==============================================================================
" = preview                                                                    =
" ==============================================================================
"
" These functions are used to preview something, either in the preview window
" or at the bottom of the screen.

" Open shell command output in the preview window
function! preview#shell(cmd)
	execute "pedit! " . tempname()
	wincmd P
	setlocal buftype=nofile
	setlocal bufhidden=delete
	setlocal nobuflisted
	setlocal noswapfile
	let l:filename = substitute(a:cmd, ' ', '_', 'g')
	let l:filename = substitute(l:filename, '[|"]', '\\&', 'g')
	execute "silent! f shell_out:" . l:filename
	call append(0, split(system(a:cmd), "\n"))
	1
endfunction

" Open man page in preview window
function! preview#man(word)
	let cmd = "man "
	let cmd .= (v:count > 0 ? v:count : "") . " "
	let cmd .= a:word
	let cmd .= ' | col -b'
	call preview#shell(cmd)
	set ft=man
endfunction

" Open output of vim command in bottom line.
function! preview#line(cmd)
	let win = winsaveview()
	let pos = getcurpos()
	let buf = bufnr("%")
	execute "keepjumps silent! " . a:cmd
	if pos == getcurpos() && buf == bufnr("%")
		echohl ErrorMsg |
		echo "E387: Match is on current line"
		echohl Normal
		return
		"let previewline="Error: Could not find line"
	endif
	let previewline=getline(".")
	execute "keepjumps silent! buf " . buf
	keepjumps call setpos(".", pos)
	call winrestview(win)
	echo previewline
endfunction

" Open output of vim command in bottom line.
function! preview#cmd(cmd)
	let win = winsaveview()
	let pos = getcurpos()
	let buf = bufnr("%")
	execute "keepjumps silent! " . a:cmd
	if pos == getcurpos() && buf == bufnr("%")
		echohl ErrorMsg |
		echo "E387: Match is on current line"
		echohl Normal
		return
		"let previewline="Error: Could not find line"
	endif
	let previewpos = getcurpos()
	let previewbuf = bufnr("%")

	execute "keepjumps silent! buf " . buf
	keepjumps call setpos(".", pos)
	call winrestview(win)

	execute "pedit! " . bufname(previewbuf)
	wincmd P
	call setpos(".", previewpos)
	wincmd w
endfunction
