" move ilist matches to qflist

function! qfinclude#qf(patt)
	let out = ""
	let init_list = &list
	set nolist
	try
		redir => out
		execute "silent ilist /" . a:patt . "/"
		redir END
	catch /E389/
		echohl ErrorMsg
		echo "E389: Couldn't find pattern"
		echohl Normal
		call setqflist([])
		let &list = init_list
		return
	endtry
	let &list = init_list

	let qf = []
	for line in split(out, '\n')
		if line !~ '^\s*\d\+:\s\+\d\+ '
			let filename = expand(line)
		else
			let text = substitute(line, '^\s*\d\+:\s\+\d\+ ', '', '')
			let lnum = split(line)[1]
			let col = stridx(text, a:patt)+1
			let qf += [{"lnum":lnum, "filename": filename, "col": col, "vcol": 1, "text": text}]
		endif
	endfor
	call setqflist(qf)
endfunction
