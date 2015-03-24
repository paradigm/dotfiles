function! diffdirs#run(...)
	tabnew
	for dir in a:000
		execute "cd " . dir
		wincmd v
		enew
		r!find . -type f | xargs sha1sum | awk '{print $2" "$1}'
		%sort
		call setline(1, dir)
		normal! ggo
		diffthis
	endfor
	wincmd b | q
	wincmd t
	normal gg
endfunction
