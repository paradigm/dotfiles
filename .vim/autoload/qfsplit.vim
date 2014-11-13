" ==============================================================================
" = qfsplit                                                                    =
" ==============================================================================
"
" vsplit the contents of the quickfix or location list aligned/scrollbound to
" current window

function! qfsplit#qf_open()
	call s:split_open()
	call s:split_load(getqflist())
	call s:split_diff()
endfunction

function! qfsplit#qf_close()
	call s:split_close()
endfunction

function! qfsplit#qf_toggle()
	if (bufwinnr("^qfsplit$") != -1)
		call s:split_close()
	else
		call s:split_open()
		call s:split_load(getqflist())
		call s:split_diff()
	endif
endfunction

function! qfsplit#qf_reload()
	call s:split_open()
	call s:split_load(getqflist())
	call s:split_diff()
endfunction

function! qfsplit#ll_open()
	call s:split_open()
	call s:split_load(getloclist(0))
	call s:split_diff()
endfunction

function! qfsplit#ll_close()
	call s:split_close()
endfunction

function! qfsplit#ll_toggle()
	if (bufwinnr("^qfsplit$") != -1)
		call s:split_close()
	else
		call s:split_open()
		call s:split_load(getloclist(0))
		call s:split_diff()
	endif
endfunction

function! qfsplit#ll_reload()
	call s:split_open()
	call s:split_load(getloclist(0))
	call s:split_diff()
endfunction

function! s:split_open()
	" If already open, switch to it and return
	if (bufwinnr("^qfsplit$") != -1)
		execute bufwinnr("^qfsplit$") . "wincmd w"
		return
	endif

	" enable diff for current/reference window
	diffthis

	" store reference window information we'll need later
	let s:ref_bufnr = bufnr("%")

	" open new scratch split
	vnew qfsplit
	setlocal buftype=nofile
	setlocal bufhidden=delete
	setlocal nobuflisted
	setlocal nonumber
	if exists('&relativenumber')
		setlocal norelativenumber
	endif
	silent! f quickfix
endfunction

function! s:split_close()
	if (bufwinnr("^qfsplit$") != -1)
		execute bufwinnr("^qfsplit$") . "wincmd w"
		bd!
	endif
endfunction

function! s:split_load(list)
	" first clear whatever is currently in the window
	1,$d

	" if the list is empty we can return here
	if len(a:list) == 0
		return
	endif

	let s:ref_line_count = len(getbufline(s:ref_bufnr, 1, "$"))

	" Ensure list is sorted by line.
	" We will filter out buffers we do not care about later.
	let list = a:list
	call sort(list, "s:compare")

	" populate window with empty lines to get a 1:1 line count with
	" reference window
	for i in range(1, s:ref_line_count)
		if i == 1
			continue
		endif
		call append(line("$"),"")
	endfor

	" populate buffer for UI and variable for diff to parse
	let offset = 0
	let s:diffout = []
	let max_line_len = 0
	for qf in list
		if qf['bufnr'] == s:ref_bufnr
			let lnum = qf['lnum'] + offset
			let text = qf['lnum'] . ". " . qf['text']
			let max_line_len = len(text) > max_line_len ? len(text) : max_line_len
			if getline(lnum) == ""
				call setline(lnum, text)
			else
				call append(lnum, text)
				let s:diffout += [qf['lnum'] . 'a' . (qf['lnum'] + offset)]
				let offset += 1
			endif
		endif
	endfor
	execute "vertical resize " . (max_line_len+3)
endfunction

function! s:split_diff()
	" call specialized diff to align lines
	let origdiffexpr = &diffexpr
	set diffexpr=s:diff()
	diffthis
	" reset diffexpr
	let &diffexpr = origdiffexpr
	" return to reference window
	wincmd p
	normal zR
endfunction

function! s:compare(left, right)
	return a:left['lnum'] - a:right['lnum']
endfunction

function! s:diff()
	let buf_new = readfile(v:fname_new)
	let buf_in = readfile(v:fname_in)
	if (buf_new == ["line1"] && buf_in == ["line2"]) || (buf_new == ["line2"] && buf_in == ["line1"])
		call writefile(["1c1"], v:fname_out)
		return
	endif

	if exists("s:diffout")
		let diffout = s:diffout
	else
		let diffout = []
	endif
	call writefile(diffout, v:fname_out)
endfunction
