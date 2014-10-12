" ==============================================================================
" = preview                                                                    =
" ==============================================================================
"
" These functions are used to preview something, either in the preview window
" or at the bottom of the screen.

" Open shell command output in the preview window
function! preview#shell(cmd)
	let tmp = tempname()
	pedit! %
	wincmd P
	enew
	setlocal buftype=nofile
	setlocal bufhidden=delete
	setlocal nobuflisted
	call append(1, split(system(a:cmd), "\n"))
	wincmd p
endfunction

" Open output of vim command in bottom line.
function! preview#line(cmd)
	let pos = getpos(".")
	let buf = bufnr("%")
	silent! execute "keepjumps " .a:cmd
	let previewline=getline(".")
	execute "keepjumps silent! buf " . buf
	keepjumps call setpos(".", pos)
	echo previewline
endfunction
