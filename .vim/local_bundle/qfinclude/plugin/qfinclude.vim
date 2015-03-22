nnoremap ]I :<c-u>call qfinclude#qf(expand("<cword>"))<cr>:call cconerror#qf()<cr>
command -nargs=+ Ilist :call qfinclude#qf(<q-args>)|call cconerror#qf()
