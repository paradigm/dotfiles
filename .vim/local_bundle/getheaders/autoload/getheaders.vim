" ==============================================================================
" = getheader                                                                  =
" ==============================================================================
"
" Get header(s) for word under cursor from man page.

function! getheaders#yank(word)
	let headers = s:get_headers(a:word)
	if len(headers) == 0
		echohl ErrorMsg
		echo "getheader: could not find any headers"
		echohl Normal
		return
	endif
	let headers += [''] " force line-wise paste
	let @" = join(headers, "\n")
	return
endfunction

function! getheaders#set(word)
	let headers = s:get_headers(a:word)
	if len(headers) == 0
		echohl ErrorMsg
		echo "getheader: could not find any headers"
		echohl Normal
		return
	endif
	let init_cursor = getcurpos()[1:]
	call cursor(1,1)
	let header_pos = searchpos('^\s*#include\s*<', 'W')
	if header_pos[0] != 0
		call cursor(init_cursor)
		call append(header_pos[0], headers)
		return
	endif

	call cursor(init_cursor)
	call append(0, headers)
	return
endfunction

function! s:get_headers(word)
	let cmd = "man "
	let cmd .= (v:count > 0 ? v:count : "") . " "
	let cmd .= a:word
	let cmd .= ' | col -b'
	let manpage = system(cmd)
	let header_lines = []
	let in_synopsis = 0
	for line in split(manpage, "\n")
		if line =~ '^\S'
			if line =~ '^SYNOPSIS'
				let in_synoposis = 1
			else
				let in_synoposis = 0
			endif
		endif
		if in_synoposis == 1 && line =~ '^\s*#include\s*<'
			let header_lines += [substitute(line, '^\s*', '', '')]
		endif
	endfor
	return header_lines
endfunction
