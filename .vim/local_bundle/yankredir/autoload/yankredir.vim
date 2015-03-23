function! yankredir#run(cmd)
	redir @"
	execute "silent! " . a:cmd
	redir END
endfunction
