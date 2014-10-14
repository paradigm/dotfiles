" ==============================================================================
" = qfsplit                                                                    =
" ==============================================================================
"
" vsplit a window the contents of the quickfix or location list scrollbound to
" the current window.
"
" TODO: this moves window around, fix that.  Maybe use winline()?
" TODO: maybe (ab)use diff so multiple qf lines can cleanly match up with main
" window.

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
	" store cursor line to restore later
	let cursor_line = line(".")

	" open new scratch split
	vnew qfsplit
	setlocal buftype=nofile
	setlocal bufhidden=delete
	setlocal nobuflisted
	" setup to scroll with main window
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

	" set qfsplit window to scrollbind in sync with main window
	keepjumps normal gg
	setlocal scrollbind

	" return to original window
	wincmd p
	" set window to scrollbind in sync with qfsplit window
	keepjumps normal gg
	setlocal scrollbind
	" restore cursor position
	execute "keepjumps normal " . cursor_line . "G"
	" Messed up the cursor position in window - try to clean it up a bit, even
	" if it's not perfectly resuming previous setup
	normal zz
endfunction
