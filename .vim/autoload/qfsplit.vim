" ==============================================================================
" = qfsplit                                                                    =
" ==============================================================================
"
" vsplit a window the contents of the quickfix or location list
" aligned/scrollbound to current window
"
" TODO: clear and restore Diff* highlight group

" populate with quickfix list
function! qfsplit#qf()
	call s:split(getqflist())
endfunction

" populate with location list
function! qfsplit#loc()
	call s:split(getloclist(0))
endfunction

" comparison for sorting list
function! s:compare(left, right)
	return a:left['lnum'] - a:right['lnum']
endfunction

" inform vim how to associate list items with reference window lines
function! s:diff()
	" vim seems to send us a test input of form "line1" vs "line2". The
	" qfsplit window will never have those contents, so we can detect that
	" situation and report back what vim wants.
	let new_buf = readfile(v:fname_new)
	let in_buf = readfile(v:fname_in)
	if (new_buf == ["line1"] && in_buf == ["line2"]) || (new_buf == ["line2"] && in_buf == ["line1"])
		call writefile(["1c1"], v:fname_out)
		return
	endif

	" this will hold the diff output that vim will parse to associate lines
	let diffout = []
	" this will track our qfsplit line number to know how to group splits
	let lnum = 0
	" this will hold the reference line number to which the current qfsplit
	" line is referring
	let ref_line = -1
	" this will hold the previous reference line number.  When this is the
	" same as ref_line we're in a group of qfsplit lines that all refer to the
	" same reference line.  Otherwise, we know we're at a boundary.  Pretend
	" there is a blank line before the very first line to make parsing easier.
	let prev_ref_line = -1
	" iterate over qfsplit lines
	for line in readfile(v:fname_new)
		" track line number
		let lnum += 1

		" blank lines don't refer to anything in the reference window
		if line == ""
			let ref_line = -1
		else
			" all qfsplit lines which do refer to something in the reference
			" window start with the line number to which they refer so it is
			" easy to parse out and track.
			let ref_line = split(line, ". ")[0]
		endif

		" We're transitioning either into or out of (or both) a block of list
		" items that correspond to the same reference window line.
		if ref_line != prev_ref_line
			if prev_ref_line != -1
				" We're transitioning out of a non-blank line.  This means the
				" previous line was the last of a block.  We've had to have
				" the start of the block earlier, so now we know the entire
				" range.
				let qf_end = lnum-1
				if qf_start != qf_end
					let diffout += [prev_ref_line . "c" . qf_start . "," . qf_end]
				else
					let diffout += [prev_ref_line . "c" . qf_start]
				endif
			endif
			" Irrelevant of what we've transitioned out of, we have just
			" transitioned into a new block
			let qf_start = lnum
		endif

		" store previous line
		let prev_ref_line = ref_line
	endfor

	" write out diff results for vim to parse
	call writefile(diffout, v:fname_out)
endfunction

" main function
function! s:split(list)

	" if a qfsplit window is already open, close it
	if (bufwinnr("^qfsplit$") != -1)
		execute bufwinnr("^qfsplit$") . "wincmd w"
		bd!
		return
	endif

	" if the list is empty, just report that
	if len(a:list) == 0
		redraw
		echo "qfsplit: list is empty"
		return
	endif

	" turn on diffing for this window to later use for line alignment.
	diffthis

	" store reference window information we'll need later
	let ref_bufnr = bufnr("%")
	let ref_linecount = line("$")

	" Ensure list is sorted by line.
	" We will filter out buffers we do not care about later.
	let list = a:list
	call sort(list, "s:compare")

	" open new scratch split
	vnew qfsplit
	setlocal buftype=nofile
	setlocal bufhidden=delete
	setlocal nobuflisted
	setlocal nonu
	setlocal nornu

	" populate window with empty lines to get a 1:1 line count with
	" reference window
	for i in range(1,ref_linecount)
		if i == 1
			continue
		endif
		call append(line("$"),"")
	endfor

	" populate list lines
	let previous_lnum = -1
	let offset = 0
	for qf in list
		if qf['bufnr'] == ref_bufnr
			if qf['lnum'] != previous_lnum
				call setline(qf['lnum'] + offset, qf['lnum'] . ". " . qf['text'])
			else
				call append(qf['lnum'] + offset, qf['lnum'] . ". " . qf['text'])
				let offset += 1
			endif
			let previous_lnum = qf['lnum']
		endif
	endfor
	" append one last blank line to make diff parsing easier
	call append(line("$"),"")

	" call specialized diff to align lines
	let origdiffexpr = &diffexpr
	set diffexpr=s:diff()
	diffthis
	" reset diffexpr
	let &diffexpr = origdiffexpr
	" return to reference window
	wincmd p
endfunction
