function! edit#run(bang, ...)
	if a:0 == 0
		execute 'e' . a:bang
		return
	endif

	" expand glob in arguments
	let args = []
	for arg in a:000
		if glob(arg) != ""
			let args += split(glob(arg), "\n")
		else
			let args += [arg]
		endif
	endfor

	" recurse down into directories
	let files = []
	for arg in args
		if isdirectory(expand(arg))
			let files += filter(split(glob(expand(arg) . '/**/*'), "\n"), '!isdirectory(v:val)')
		else
			let files += [expand(arg)]
		endif
	endfor

	" :e first item, :badd the rest
	let max = len(files) > g:edit_max ? g:edit_max : len(files)
	if len(files) > 0
		execute 'e ' . a:bang . ' ' . files[0]
		for i in range(1, max-1)
			execute 'badd ' . files[i]
		endfor
	endif

	" warn if we found more than g:edit_max files
	if len(files) > g:edit_max
		redraw
		echohl ErrorMsg
		echo "E: hit max"
		echohl Normal
	endif
endfunction
