" ==============================================================================
" = ftstack                                                                    =
" ==============================================================================
"
" Vim supports hooks for language-specific "smart" jumping to
" definitions/declarations.  However, it doesn't support a way to let these
" hook into the tag stack.  These functions mimic the tag stack in a way that
" is accessible via vimscript.

function! ftstack#push()
	if !exists("g:ftstack")
		let g:ftstack = []
	endif
	" add to jumplist
	execute "keeppatterns normal! /\\%" . line(".") . "l\\%" . col(".") . "c\<cr>"
	let g:ftstack += [[expand("%"), bufnr("%"), getcurpos()]]
endfunction

function! ftstack#pop()
	if !exists("g:ftstack") || len(g:ftstack) == 0
		redraw
		echohl ErrorMsg
		echo "E73: tag stack empty"
		echohl None
		return
	endif
	if g:ftstack[-1][0] != ""
		execute "e " . g:ftstack[-1][0]
	else
		execute "b " . g:ftstack[-1][1]
	endif
	call setpos(".", g:ftstack[-1][2])
	let g:ftstack = g:ftstack[:-2]
endfunction
