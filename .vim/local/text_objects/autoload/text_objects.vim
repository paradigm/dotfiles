" -----------------------------------------------------------------------------
" function to create new text objects

function! text_objects#add(keys, i_cmd, a_cmd)
	execute 'xnoremap <silent> i' . a:keys . ' :<c-u>' . a:i_cmd . '<cr>'
	execute 'onoremap <silent> i' . a:keys . ' :normal vi' . a:keys . '<cr>'
	execute 'xnoremap <silent> a' . a:keys . ' :<c-u>' . a:a_cmd . '<cr>'
	execute 'onoremap <silent> a' . a:keys . ' :normal va' . a:keys . '<cr>'
endfunction

" -----------------------------------------------------------------------------
" indent text object

function! s:select_indent(around)
	let init_indent = indent(line("."))
	let start = line(".")
	let end = start
	" search up
	while start != 1 && (indent(start - 1) >= init_indent || getline(start - 1) == "")
		let start -= 1
	endwhile
	if a:around && start != 1
		let start -= 1
	endif
	" search down
	while end != line("$") && (indent(end + 1) >= init_indent || getline(end + 1) == "")
		let end += 1
	endwhile
	if a:around && end != line("$")
		let end += 1
	endif
	execute "normal! \<esc>V" . start . "Go" . end . "G"
endfunction

function! s:get_range()
	return [bufnr("%"), getpos("'<"), getpos("'>")]
endfunction

function! text_objects#inner_indent()
	if exists("s:previous_indent_range") && s:previous_indent_range == s:get_range()
		" re-selecting, expand region
		call s:select_indent(1)
	endif
	call s:select_indent(0)
	call s:select_indent(0)
	let s:previous_indent_range = s:get_range()
endfunction

function! text_objects#around_indent()
	call s:select_indent(1)
	let s:previous_indent_range = s:get_range()
endfunction

" -----------------------------------------------------------------------------
" text object for column of identical characters

function! text_objects#similar_column()
	let start_line = line(".")
	let end_line = line(".")
	let start_col = col(".")-1
	let char = getline(".")[start_col]

	" search up
	while start_line != 1 && getline(start_line-1)[start_col] ==# char
		let start_line -= 1
	endwhile
	" search down
	while end_line != line("$") && getline(end_line+1)[start_col] ==# char
		let end_line += 1
	endwhile

	let pos = getpos(".")
	let pos[1] = start_line
	call setpos(".", pos)
	execute "normal! \<c-v>" . (end_line - start_line) . "\<down>"
endfunction
