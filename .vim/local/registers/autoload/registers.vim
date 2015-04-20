" TODO:
" support for @ on cmdline
" - no plan for doing this
" support for @@ in normal mode
" - maybe map <expr> @@?

function! registers#add(keys, expression)
	execute 'nnoremap "'          . a:keys . ' "='          . a:expression . "\<cr>"
	execute 'nnoremap @'          . a:keys . ' @='          . a:expression . "\<cr>"
	execute 'inoremap <c-r>'      . a:keys . ' <c-r>='      . a:expression . "\<cr>"
	execute 'inoremap <c-r><c-r>' . a:keys . ' <c-r><c-r>=' . a:expression . "\<cr>"
	execute 'inoremap <c-r><c-o>' . a:keys . ' <c-r><c-o>=' . a:expression . "\<cr>"
	execute 'inoremap <c-r><c-p>' . a:keys . ' <c-r><c-p>=' . a:expression . "\<cr>"
endfunction
