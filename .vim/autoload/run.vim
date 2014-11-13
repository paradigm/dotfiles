" ==============================================================================
" = run                                                                        =
" ==============================================================================

function! run#run(type)
	if exists("g:Runpath")
		let l:runpath = g:Runpath
		let l:runcmd = g:Runpath
		let l:runquiet = get(g:, "Runquiet", 0)
	elseif exists("g:Runcmd")
		let l:runpath = ""
		let l:runcmd = g:Runcmd
		let l:runquiet = get(g:, "Runquiet", 0)
	elseif exists("b:runpath")
		let l:runpath = b:runpath
		let l:runcmd = b:runpath
		let l:runquiet = get(b:, "runquiet", 0)
		cd %:p:h
	elseif exists("b:runcmd")
		let l:runpath = ""
		let l:runcmd = b:runcmd
		let l:runquiet = get(b:, "runquiet", 0)
		cd %:p:h
	else
		echohl ErrorMsg
		echo "Run: nothing to run set"
		echohl None
		return
	endif

	if l:runpath != "" && !filereadable(l:runpath)
		echohl ErrorMsg
		echo "Run: Could not find file at \"" . l:runpath . "\""
		echohl None
		return
	endif

	if l:runpath != "" && !executable(l:runpath)
		redraw!
		echo "Set " . runpath . " as executable? (y/n) "
		if nr2char(getchar()) == "y"
			call system("chmod u+x " . l:runpath)
		else
			return
		endif
	endif

	if a:type == "sh" && !l:runquiet
		silent! :!clear
		redraw!
		execute "!" . l:runcmd
	elseif a:type == "sh" && l:runquiet
		call system(l:runcmd . "&")
	elseif a:type == "preview"
		call preview#shell(l:runcmd)
	elseif a:type == "xterm"
		if exists("g:last_run_pid")
			echo system('kill ' . g:last_run_pid . " >/dev/null 2>&1")
		endif
		let g:last_run_pid = system('xterm -e sh -c "' . l:runcmd . '; echo; echo RETURNED $?; echo PRESS ENTER TO CLOSE; read PAUSE" & echo $!')
	endif
	return
endfunction

" Completion for :Run
function! run#complete(A,L,P)
	let regex = glob2regex#conv(a:A)
	let options = ["sh", "preview", "xterm"]
	let results = []
	for option in options
		if option =~ regex
			let results += [option]
		endif
	endfor
	return results
endfunction
