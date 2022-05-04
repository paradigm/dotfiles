" ==============================================================================
" = ledger ftplugin                                                             =
" ==============================================================================

call snippet#add(";;","
\<c-r>=system('date --iso')[:-2]<cr> <++><cr>
\<++>	$<++><cr>
\<++>")

function! FormatTransaction()
	normal! vipmboma
	while getline("'b") !~ "^\t"
		normal `bkmb
	endwhile
	'a,'bTabularize /.\zs\t\ze[^\t ]
	undojoin
	'a,'bretab
	undojoin
	'a,'bs/\t /\t/
endfunction
command! FormatTransaction call FormatTransaction()
