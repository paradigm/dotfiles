" cd to directory containing current buffer
command! -bar CD :cd %:p:h
command! -bar Cd :cd %:p:h

" Command to see the element name for character under cursor.  Very helpful
" run to see element name under color
command! -bar SyntaxGroup echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')

command! -bar Scratch new|setlocal buftype=nofile bufhidden=delete noswapfile

command! -bar -nargs=+ YankRedir redir @" | execute "silent! " . <q-args> | redir END

command! -nargs=+ Profile execute 'profile start ' . split("<args>")[0] . '|profile file *|profile func *|' . join(split("<args>")[1:], ' ')  | noautocmd qa!

command! -nargs=+ -complete=help H help <args> | pedit % | q
