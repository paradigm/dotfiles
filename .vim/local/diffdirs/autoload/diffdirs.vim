function! diffdirs#run(...)
	if !exists("s:dirs") || a:000 != []
		let s:dirs=a:000
		let s:cwd=getcwd()
	endif
	tabnew
	for dir in s:dirs
		execute "lcd " . s:cwd
		execute "lcd " . dir
		wincmd v
		enew
		call support#scratch()
		set filetype=diffdirs
		r!find . -type f | xargs sha1sum | awk '{print $2" "$1}'
		%sort
		call setline(1, '### ' . dir . ' ###')
		normal! ggo
		diffthis
		nnoremap <buffer> <c-]> :call diffdirs#difffile(expand("<cWORD>"))<cr>
	endfor
	wincmd b | q
	wincmd t
	normal gg
	execute "cd " . s:cwd
endfunction

function! diffdirs#difffile(filename)
	tabnew
	for dir in s:dirs
		execute "lcd " . s:cwd
		execute "lcd " . dir
		wincmd v
		enew
		execute "e " . a:filename
		diffthis
	endfor
	wincmd b | q
	wincmd t
	normal gg
endfunction

function! diffdirs#update()
	if &filetype == "diffdirs"
		windo q
		execute "cd " . s:cwd
		call diffdirs#run()
	else
		redraw
		echohl ErrorMsg
		echo "Not in a diffdirs window"
		echohl Normal
	endif
endfunction
