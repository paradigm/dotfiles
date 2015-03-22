function! retabline#run(line)
	" make scratch buffer to apply retab to
	new|setlocal buftype=nofile bufhidden=delete noswapfile expandtab
	call setline(1, a:line)
	retab

	" save line
	let new_line = getline(1)

	" close scratch window
	noautocmd q

	return new_line
endfunction
