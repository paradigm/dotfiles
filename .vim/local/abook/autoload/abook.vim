function! abook#omnicomplete(findstart, base)
	if a:findstart == 1
		return strlen(substitute(getline(".")[:col(".")-2], '\<\w*$', '', ''))
	else
		let res = []
		for msg in split(system("abook --mutt-query " . shellescape(a:base)), '\n')
			if msg == "Not found"
				continue
			endif
			let email = split(msg, '\t')[0]
			let name = substitute(join(split(msg, '\t')[1:]), '\s*$', '', '')
			call add(res, name . ' <' . email . '>')
		endfor
		return res
	endif
endfunction
