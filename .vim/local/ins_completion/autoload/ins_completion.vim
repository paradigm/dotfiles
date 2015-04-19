" Run an ins-completion with specified 'complete' then restore when done
function! ins_completion#settings(settings)
	let g:init_complete = &complete
	let &complete=a:settings
	augroup InsCompletion
		autocmd!
		autocmd CompleteDone * let &complete=get(g:,"init_complete",".") | autocmd! InsCompletion
	augroup END
endfunction
