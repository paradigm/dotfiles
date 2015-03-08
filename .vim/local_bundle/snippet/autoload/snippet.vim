" ==============================================================================
" = snippet                                                                    =
" ==============================================================================

function! snippet#map(input, output)
	execute "inoremap " . a:input . " " . a:output . "<c-r>=snippet#jump()<cr>"
endfunction

" Jumps to next <++>.  Conceptually based on vim-latexsuite's equivalent.
function! snippet#jump()
	let start = searchpos('\V\zs<+\.\{-\}+>','cw')
	let end = searchpos('\V<+\.\{-\}+\zs>','cw')
	return "\<esc>/\\%" . start[0] . "l\\%" . start[1] . "c\<cr>v" .
				\ "/\\%" . end[0] . "l\\%" . end[1] . "c\<cr>" .
				\ "\<esc>:nohl\<cr>gv\<c-g>"
endfunction

" Accepts the current snippet
function! snippet#next()
	return "\<esc>" . snippet#jump()
	normal! `>h2x
	normal! `<2x
	let
	call snippet#jump()
endfunction
