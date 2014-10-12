" ==============================================================================
" = ftstack                                                                    =
" ==============================================================================
"
" Vim supports hooks for language-specific "smart" jumping to
" definitions/declarations.  However, it doesn't support a way to let these
" hook into the tag stack.  These functions mimic that effect.

" Push current location onto the ftstack
function! ftstack#push()
	if !exists("g:ftstack")
		let g:ftstack = []
	endif
	let g:ftstack += [[expand("%"), line("."), virtcol(".")]]
endfunction

" Pop the stack
function! ftstack#pop()
	if !exists("g:ftstack") || len(g:ftstack) == 0
		redraw
		echo "Tag Stack Empty"
		return
	endif
	execute "e " . g:ftstack[-1][0]
	execute "normal " . g:ftstack[-1][1] . "G"
	execute "normal " . g:ftstack[-1][2] . "|"
	let g:ftstack = g:ftstack[:-2]
endfunction
