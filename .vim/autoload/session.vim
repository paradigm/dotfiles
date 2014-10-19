" ==============================================================================
" = session                                                                    =
" ==============================================================================
"
" session management

function! session#save(...)
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

	" If we're in a git-managed project, save symlink to git project and
	" actual session info in .git as branch name.
	"
	" Otherwise, save session info normally.
	let git_top = system("git rev-parse --show-toplevel")[:-2]
	if git_top[0] == "/"
		" make symlink to git project
		call system("mkdir -p " . $HOME . "/.vim/sessions")
		call system("ln -s '" . git_top . "' " . $HOME . "/.vim/sessions/" . name)
		" make session file at .git/vimsessions/branch-name
		let branch = system("git branch | awk '$1==\"*\"{print$2}'")[:-2]
		let session_path = git_top . "/.git/vimsessions/" . branch
		call system("mkdir -p " . git_top . "/.git/vimsessions")
		execute "mksession!  " . session_path
		redraw
		echo "Saved Session \"" . name . "\" (" . branch . ")"
	else
		" make session file at ~/.vim/sessions
		call system("mkdir -p " . $HOME . "/.vim/sessions")
		let session_path = $HOME . "/.vim/sessions/" . name
		execute "mksession!  " . session_path
		redraw
		echo "Saved Session \"" . name . "\""
	endif

	" auto-update session just before leaving vim
	let g:session_name = name
	augroup session
		autocmd!
		autocmd VimLeavePre * if bufname("%") != "" | call session#save(g:session_name) | endif
	augroup END
endfunction

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

function! session#load(...)
	" get name for session
	if a:0 == 0
		let name = input("Load Session Name: ")
	else
		let name = a:1
	endif

	" Check if session exists
	let session_path = $HOME . "/.vim/sessions/" . name
	if system("[ -e " . session_path . " ]; echo $?") == 1
		redraw
		echohl ErrorMsg
		echo "Cannot find session \"" . name . "\""
		echohl None
		return
	endif

	" If target is symlink, session file is stored in $SYMLINK/.git/$BRANCH
	" Otherwise session file is at target
	let branch = ""
	if system("[ -h " . session_path . " ]; echo $?") == 0
		exec "cd " . session_path
		let branch = system("git branch | awk '$1==\"*\"{print$2}'")[:-2]
		let session_path = "./.git/vimsessions/" . branch
	endif

	execute "source " . session_path

	" auto-update session just before leaving vim
	let g:session_name = name
	augroup session
		autocmd! session
		autocmd VimLeavePre * if bufname("%") != "" | call session#save(g:session_name) | endif
	augroup END

	redraw
	if branch == ""
		echo "Loaded Session \"" . name . "\""
	else
		echo "Loaded Session \"" . name . "\" (" . branch . ")"
	endif
endfunction
