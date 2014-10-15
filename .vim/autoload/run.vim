" ==============================================================================
" = run                                                                        =
" ==============================================================================

" Try to make an educated guess on what to run given the current filetype and
" context.  Also helps set executable if needed.

function! run#run(type)
	" Move the directory containing the current buffer.  This is helpful in
	" case multiple buffers are open which have different associated
	" ./a.out or equivalent
	cd %:p:h
	" Determine what to run
	let l:quiet = 0
	if exists("g:Runcmd")
		let l:runcmd = g:Runcmd
	elseif &ft == "c"
		let l:runpath = "./a.out"
		let l:runcmd = l:runpath
	elseif &ft == "cpp"
		let l:runpath = "./a.out"
		let l:runcmd = l:runpath
	elseif &ft == "java"
		" assumes eclim
		autocmd! eclim_java
		autocmd! eclim_show_error
		let l:project = eclim#project#util#GetCurrentProjectName()
		let l:runcmd = "eclim -editor vim -command java -p " . l:project
	elseif &ft == "python"
		let l:runpath = expand("%:p")
		let l:runcmd = l:runpath
	elseif &ft == "sh"
		let l:runpath = expand("%:p")
		let l:runcmd = l:runpath
	elseif &ft == "tex"
		" reload pdf reader
		let l:runcmd = "pkill -HUP mupdf"
		let l:quiet = 1
	elseif &ft == "dot"
		" reload image viewer
		let l:runcmd = "xdotool search --name sxiv key r"
		let l:quiet = 1
	endif

	if exists("l:runpath") && !filereadable(l:runpath)
		echohl ErrorMsg
		echo "Run: Could not find file at \"" . l:runpath . "\""
		echohl None
		return
	endif

	if exists("l:runpath") && !executable(l:runpath)
		redraw!
		echo "Set " . runpath . " as executable? (y/n) "
		if nr2char(getchar()) == "y"
			call system("chmod u+x " . l:runpath)
		else
			return
		endif
	endif

	if a:type == "sh" && !l:quiet
		silent! :!clear
		redraw!
		execute "!" . l:runcmd
	elseif a:type == "sh" && l:quiet
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
	if a:A[-1:] != "*"
		let globpattern = a:A . "*"
	else
		let globpattern = a:A
	endif
	let globpattern = substitute(globpattern, "*", ".*", "g")
	let options = ["sh", "preview", "xterm"]
	let results = []
	for option in options
		if match(option, globpattern) != -1
			let results += [option]
		endif
	endfor
	return results
endfunction
