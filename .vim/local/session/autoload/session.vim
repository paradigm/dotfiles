function! session#list(A,L,P)
	if a:A[-1:] != "*"
		let globpattern = a:A . "*"
	else
		let globpattern = a:A
	endif
	let sessions = []
	for session in split(globpath($HOME . "/.vim/sessions", globpattern),'\n')
		let sessions += [fnamemodify(session, ":t")]
	endfor
	return sessions
endfunction

function! session#save(bang, ...)
	" if it looks like maybe the user wanted to load, not save, be careful
	" not to overwrite with blank project
	if bufname("%") == ""
		redraw
		echohl ErrorMsg
		echo "Refusing to overwrite when current buffer is unnamed"
		echohl None
		return
	endif

	" get name for session
	if a:0 == 0
		let name = input("Save Session Name: ")
	else
		let name = a:1
	endif
	if name == ""
		redraw
		echohl ErrorMsg
		echo "No name set, aborting"
		echohl None
		return
	endif

	if !isdirectory($HOME . "/.vim/sessions")
		call mkdir($HOME . "/.vim/sessions")
	endif
	if filereadable($HOME . "/.vim/sessions/" . name) && !a:bang
		redraw
		echohl ErrorMsg
		echo "Session \"" . name . "\" already exists, use \"SessionSave!\" to overwrite"
		echohl Normal
		return
	endif

	execute "mksession!  " . $HOME . "/.vim/sessions/" . name
	redraw
	echo "Saved Session \"" . name . "\""

	" auto-update session just before leaving vim
	let g:session_name = name
	augroup session
		autocmd!
		autocmd VimLeavePre * if bufname("%") != "" | call session#save(1, g:session_name) | endif
	augroup END

	redraw
	echo "Session: saved " . g:session_name
endfunction

function! session#load(...)
	" get name for session
	if a:0 == 0
		echo "Sessions:"
		for session in split(globpath($HOME . "/.vim/sessions", "*"),'\n')
			echo "  " . fnamemodify(session, ":t")
		endfor
		let name = input("Load Session Name: ")
	else
		let name = a:1
	endif

	" Check if session exists
	let session_path = $HOME . "/.vim/sessions/" . name
	if !filereadable(session_path)
		redraw
		echohl ErrorMsg
		echo "Cannot find session \"" . name . "\""
		echohl None
		return
	endif

	execute "source " . session_path

	" auto-update session just before leaving vim
	let g:session_name = name
	augroup session
		autocmd! session
		autocmd VimLeavePre * if bufname("%") != "" | call session#save(1, g:session_name) | endif
	augroup END

	redraw
	echo "Session: loaded " . name
endfunction
