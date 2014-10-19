" ==============================================================================
" = tagfile                                                                    =
" ==============================================================================
"
" Maintains a list of files for quick access

function! tagfile#set(tag)
	call system("mkdir -p " . $HOME . "/.vim/filetags")
	call system("ln -s '" . expand("%:p") . "' " . $HOME . "/.vim/filetags/" . a:tag)
endfunction

function! tagfile#complete(A,L,P)
	if a:A[-1:] != "*"
		let globpattern = a:A . "*"
	else
		let globpattern = a:A
	endif
	let tagfiles = []
	for tagfile in split(globpath($HOME . "/.vim/filetags/",globpattern),'\n')
		let tagfiles += [fnamemodify(tagfile, ":t")]
	endfor
	return tagfiles
endfunction

function! tagfile#get(tag)
	" read the link and edit the actual place instead of editing the link
	" so vim shows the real path
	execute ":e " . system("readlink " . $HOME . "/.vim/filetags/" . a:tag)
endfunction
