function! edit#run(bang, ...)
	if a:0 == 0
		execute 'e' . a:bang
		return
	endif
	let files = []
	for arg in a:000
		if isdirectory(expand(arg))
			for entry in split(glob(expand(arg) . '/**/*'), "\n")
				if !isdirectory(expand(entry))
					let files += [expand(entry)]
				endif
			endfor
		else
			let files += [expand(entry)]
		endif
	endfor
	for i in range(0, (len(files) > g:edit_max ? g:edit_max : len(files))-1)
		execute 'e' . a:bang . ' ' . files[i]
	endfor
	if len(files) > g:edit_max
		echohl ErrorMsg
		echo "E: hit max"
		echohl Normal
	endif
endfunction
