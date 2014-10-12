" ==============================================================================
" = markfile                                                                   =
" ==============================================================================


function! markfile#set(mark)
	call system("mkdir -p " . $HOME . "/.vim/filemarks")
	call system("ln -s '" . expand("%:p") . "' " . $HOME . "/.vim/filemarks/" . a:mark)
endfunction

function! markfile#complete(A,L,P)
	if a:A[-1:] != "*"
		let globpattern = a:A . "*"
	else
		let globpattern = a:A
	endif
	let filemarks = []
	for filemark in split(globpath($HOME . "/.vim/filemarks",globpattern),'\n')
		let filemarks += [fnamemodify(filemark, ":t")]
	endfor
	return filemarks
endfunction

function! markfile#get(mark)
	" read the link and edit the actual place instead of editing the link
	" so vim shows the real path
	execute ":e " . system("readlink " . $HOME . "/.vim/filemarks/" . a:mark)
endfunction
