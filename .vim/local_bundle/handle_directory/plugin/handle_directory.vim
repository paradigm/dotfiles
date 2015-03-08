let g:handle_directory_cmd = 'call skybison#run("e " . g:handle_directory_arg . "/")'

augroup HandleDirectory
	autocmd BufEnter * call s:HandleDirectory(expand("<amatch>"))
	autocmd VimEnter * call s:VimEnterHandleDirectory(expand("<amatch>"))
augroup END

function! s:HandleDirectory(file)
	if exists("s:vim_entered") && isdirectory(a:file)
		let g:handle_directory_arg = a:file
		execute g:handle_directory_cmd
	endif
endfunction

function! s:VimEnterHandleDirectory(file)
	let s:vim_entered = 1
	if isdirectory(a:file)
		let g:handle_directory_arg = a:file
		execute g:handle_directory_cmd
	endif
endfunction
