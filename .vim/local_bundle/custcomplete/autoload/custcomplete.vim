" ==============================================================================
" = custcomplete                                                               =
" ==============================================================================
"
" Run an ins-completion with specified 'complete' then restore when done

function! custcomplete#run(settings)
	let g:init_complete = &complete
	let &complete=a:settings
	augroup CustComplete
		autocmd!
		autocmd CompleteDone * let &complete=get(g:,"init_complete",".") | autocmd! CustComplete
	augroup END
endfunction
