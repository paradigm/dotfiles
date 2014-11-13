" ==============================================================================
" = diffsigns                                                                  =
" ==============================================================================
"
" populate sign column items with diff values

if get(g:, "diffsigns_disablehighlight", 0)
	highlight DiffAdd    NONE
	highlight DiffChange NONE
	highlight DiffDelete NONE
	highlight DiffText   NONE
endif

" Detect if vim threw actual diff at us or a test.  If a test, handle it and
" indicate it was a test.
function! s:handle_test()
	let buf_new = readfile(v:fname_new)
	let buf_in = readfile(v:fname_in)
	if (buf_new == ["line1"] && buf_in == ["line2"]) || (buf_new == ["line2"] && buf_in == ["line1"])
		call writefile(["1c1"], v:fname_out)
		return 1
	endif
	return 0
endfunction

" Setup sign variables and clear existing sign contents
function! s:setup_sign_column()
	sign define added   text=++ texthl=DiffAdd
	sign define deleted text=-- texthl=DiffDelete
	sign define changed text=!! texthl=DiffChange
	sign unplace *
endfunction

" Do actual diff for vim to have parse-able output
" returns whether or not two input files were identical
function! s:do_diff()
	let opt = ""
	if &diffopt =~ "icase"
		let opt = opt . "-i "
	endif
	if &diffopt =~ "iwhite"
		let opt = opt . "-b "
	endif
	" run diff
	call system("diff -a --binary " . opt . v:fname_in . " " . v:fname_new . " > " . v:fname_out)
	return readfile(v:fname_out) == []
endfunction

" returns which buffer numbers associate with which diff inputs
function! s:associate_buffers()
	let fname_in = readfile(v:fname_in)
	let fname_new = readfile(v:fname_new)
	let buf_in = -1
	let buf_new = -1
	for win in range(1,winnr("$"))
		let bufnr = winbufnr(win)
		let buflist = getbufline(bufnr, 1, "$")
		if buflist == fname_in
			let buf_in = bufnr
		endif
		if buflist == fname_new
			let buf_new = bufnr
		endif
	endfor
	return [buf_in, buf_new]
endfunction

" iterates over diff output and places signs in specified buffers accordingly
function! s:set_signs(buf_in, buf_new)
	for line in readfile(v:fname_out)
		" we only care about the lines that tell us which lines were changed, not the actual changes
		if line !~ "^[0-9]"
			continue
		endif

		" parse out diff line
		let in_start   =  matchstr(split(line, "[acd]")[0], "^[^,]*")
		let in_end     =  matchstr(split(line, "[acd]")[0], "[^,]*$")
		let new_start  =  matchstr(split(line, "[acd]")[1], "^[^,]*")
		let new_end    =  matchstr(split(line, "[acd]")[1], "[^,]*$")
		let changetype = split(line, "[0-9,]")[0]

		" determine what signs to place in what buffers based on changetype
		if changetype == "a"
			let signtype_new = "added"
			let signtype_in = "deleted"
		elseif changetype == "d"
			let signtype_new = "deleted"
			let signtype_in = "added"
		elseif changetype == "c"
			let signtype_new = "changed"
			let signtype_in = "changed"
		else
			" this should never occur
			echohl ErrorMsg
			echo "DiffSigns: Error parsing diff output"
			echohl None
			return
		endif

		" loop over range placing signs
		" vim does not let us place signs in the non-numbered filler lines
		" that correspond to deleted lines
		for lnum in range(new_start, new_end)
			if signtype_new != "deleted"
				execute "sign place 1 line=" . lnum . " name=" . signtype_new . " buffer=" . a:buf_new
			endif
		endfor
		for lnum in range(in_start, in_end)
			if signtype_in != "deleted"
				execute "sign place 1 line=" . lnum . " name=" . signtype_in . " buffer=" . a:buf_in
			endif
		endfor
	endfor
endfunction

" main function
function! diffsigns#run()
	" Vim throws test at us to make sure we work.  The test inputs do not
	" associate with any buffer which breaks sign placement later.  Detect
	" test and return before sign calculations.
	if s:handle_test()
		return
	endif

	" set up sign column
	call s:setup_sign_column()

	" do actual diff so vim knows how to align things
	let diff_identical =  s:do_diff()

	" if the two files were identical, nothing more to do
	if diff_identical
		return
	endif

	" figure out which buffers correspond to v:fname_in and v:fname_new so we
	" know where to place signs
	let [buf_in, buf_new] = s:associate_buffers()

	" just in case the above somehow fails, report it
	if buf_in == -1 || buf_new == -1
		echohl ErrorMsg
		echo "DiffSigns: Could not find both diff windows"
		echohl None
		return
	endif

	" set signs
	call s:set_signs(buf_in, buf_new)
endfunction
