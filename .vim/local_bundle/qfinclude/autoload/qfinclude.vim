" move ilist matches to qflist

function! qfinclude#qf(patt)
	let out = ""
	try
		redir => out
		execute "silent ilist /" . a:patt . "/"
		redir END
	catch /E389/
		echohl ErrorMsg
		echo "E389: Couldn't find pattern"
		echohl Normal
		call setqflist([])
		return
	endtry

	let qf = []
	for line in split(out, '\n')
		if filereadable(expand(line))
			let filename = expand(line)
		else
			let lnum = split(line)[1]
			let text = substitute(line, '^\s*\d\+:\s\+\d\+ ', '', '')
			let qf += [{"filename": filename, "lnum": lnum, "text": text}]
		endif
	endfor
	call setqflist(qf)
endfunction
