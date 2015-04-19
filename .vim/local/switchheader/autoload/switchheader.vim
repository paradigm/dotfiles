" ==============================================================================
" = switchheader                                                               =
" ==============================================================================

function! switchheader#run()
	let filebase = expand("%:t:r")
	" Add extra dir layer here so the while loop below will start at the
	" proper place, since there's no do/while.
	let dirbase = expand("%:p:h") . "/"
	let extension = expand("%:t:e")
	if extension == "h"
		let targets = [".c", ".cpp", ".C", ".cc", "cxx"]
	else
		let targets = [".h", ".hh", ".hxx", ".hpp"]
	endif
	while dirbase != "/"
		let dirbase = fnamemodify(dirbase, ":h")
		for target in targets
			for subdir in ["", "c/", "include/"]
				let p = dirbase . "/" . subdir . filebase . target
				if filereadable(p)
					exec ":e " . p
					return
				endif
			endfor
		endfor
	endwhile
	redraw
	echohl ErrorMsg
	echo "Could not find header"
	echohl None
endfunction
