" ==============================================================================
" = togglecomment                                                              =
" ==============================================================================

function! togglecomment#run()
	" Determine comment character(s) based on filetype.  Vim sets &commentstring
	" to the relevant value, but also include '%s' which we want to strip out.
	let b:commentcharacters = substitute(&commentstring,"%s","","")
	" The way this function is designed, multi-line comments don't work.  For
	" C-style languages, use // ... instead of /* ... */
	if b:commentcharacters == "/**/"
		let b:commentcharacters = "//"
	endif
	if getline(".") =~ "^" . b:commentcharacters . " "
		" line is commented, uncomment
		execute "s,^" . b:commentcharacters . " ,,e"
		nohlsearch
	else 
		" line is not commented, comment it
		execute "s,^," . b:commentcharacters . " ,"
		nohlsearch
	endif
endfunction

