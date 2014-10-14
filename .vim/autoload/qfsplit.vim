" ==============================================================================
" = qfsplit                                                                    =
" ==============================================================================
"
" vsplit a window the contents of the quickfix or location list scrollbound to
" the current window.

" populate with quickfix list
function! qfsplit#qf()
	call s:qfsplit(getqflist())
endfunction

" populate with location list
function! qfsplit#loc()
	call s:qfsplit(getloclist(0))
endfunction

function! s:qfsplit(list)
	" if window is already open, close it
	let winnr = winbufnr('^qfsplit$')
	let qfsplitbuf = get(g:,"qfsplitbuf",-1)
	if winnr != -1 && qfsplitbuf != -1
		execute winnr . 'wincmd w'
		if bufnr("%") == qfsplitbuf
			bd
			return
		endif
	endif

	" store current buffer number to reference
	let bufnr = bufnr("%")
	" set current window to scrollbind
	setlocal scrollbind
	" store cursor position to restore later
	let pos = getpos(".")
	let pos[0] = bufnr(".")

	" open new scratch split
	vnew qfsplit
	setlocal buftype=nofile
	setlocal bufhidden=delete
	setlocal nobuflisted
	" setup to scroll with main window
	setlocal scrollbind
	setlocal nowrap
	" remember scratch new buffer number to reference
	let g:qfsplitbuf = bufnr("%")

	" populate with list contents
	let c={}
	for qf in a:list
		if qf['bufnr'] == bufnr
			" ensure we have enough lines
			while line("$") < qf['lnum']
				call append(line('$'), "")
			endwhile
			let lnum = qf['lnum']
			if getline(lnum) == ""
				" set new content
				call setline(lnum, qf['text'])
				let c[lnum] = 1
			else
				" append new item to current content
				call setline(lnum, getline(lnum) . " | " . qf['text'])
				let c[lnum] = c[lnum] + 1
			endif
		endif
	endfor
	" populate item count numbers per line so user knows to scroll
	for lnum in keys(c)
		call setline(lnum, "[" . c[lnum] . "] " . getline(lnum))
	endfor

	" return to original window
	wincmd p
	" restore cursor position
	call setpos(".", pos)
endfunction
