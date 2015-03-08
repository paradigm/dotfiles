" select range by indent

function! select_indent#inner()
	if exists("s:prev_range") && s:prev_range == s:get_range()
		" re-selecting, expand region
		call s:select(1)
	endif
	call s:select(0)
	call s:select(0)
	let s:prev_range = s:get_range()
endfunction

function! select_indent#extern()
	call s:select(1)
	let s:prev_range = s:get_range()
endfunction

function! s:get_range()
	return [bufnr("%"), getpos("'<"), getpos("'>")]
endfunction

function! s:select(extern)
	let init_indent = indent(line("."))
	let start = line(".")
	let end = start
	while start != 1 && (indent(start - 1) >= init_indent || getline(start - 1) == "")
		let start -= 1
	endwhile
	if (a:extern) && start != 1
		let start -= 1
	endif
	while end != line("$") && (indent(end + 1) >= init_indent || getline(end + 1) == "")
		let end += 1
	endwhile
	if (a:extern) && end != line("$")
		let end += 1
	endif
	execute "normal! \<esc>" . end . "GV" . start . "G"
endfunction
