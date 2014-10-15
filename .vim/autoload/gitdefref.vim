" ==============================================================================
" = gitdefref                                                                  =
" ==============================================================================

" Wrapper for fugitive's Git diff against a stored reference point.  The
" variable that stores the reference contains a capital so that, with
" sessionoptions=globals it will be carried through a session.

function! gitdefref#complete(A,L,P)
	" attempt to simulate vim ins-completion globbing
	let l:filter = substitute(a:A, "*", ".*", "g")
	if (l:filter !~ "*$")
		let l:filter = l:filter . ".*"
	endif
	" get refs
	let refs = []
	for line in split(system("git branch | sed 's/[ *]//g'"))
		if line =~ filter
			let refs += [line]
		endif
	endfor
	for line in split(system("git tag"))
		if line =~ filter
			let refs += [line]
		endif
	endfor
	return refs
endfunction

function! gitdefref#run(...)
	if a:0 != 0 && a:1 != ""
		let g:Diffref = a:1
	endif
	execute "Gvdiff " . get(g:, "Diffref", "")
endfunction
