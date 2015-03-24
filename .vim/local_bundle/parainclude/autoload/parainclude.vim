function! parainclude#include_files()
	redir => outstr
		silent checkpath!
	redir END
	let outlst = split(outstr, '\n')[1:]

	let filenames = []
	for filename in outlst
		if split(filename)[-1] == '-->'
			continue
		endif
		if split(filename)[-2:] == ["NOT", "FOUND"]
			continue
		endif
		if split(filename)[-2:] == ["(Already", "listed)"]
			continue
		endif
		let filenames += [substitute(filename,'^\s*','','')]
	endfor
	let filenames += [expand("%:p")]
	return filenames
endfunction

function! parainclude#imatches(pattern)
	let filenames = parainclude#include_files()
	if &l:include != ''
		let include = &l:include
	else
		let include = &g:include
	endif

	tabnew|setlocal buftype=nofile bufhidden=delete noswapfile

	let matches=[]
	for filename in filenames
		%d
		call append(1, bufexists(filename) ? getbufline(filename, 1, "$") : readfile(filename))
		1d

		let flags='Wc'
		call cursor(0,0,0)
		while search(a:pattern, flags) != 0
			let flags='W'
			if getline(".") =~ include
				continue
			endif
			let matches += [{
						\'filename': filename,
						\'lnum': line("."),
						\'col': col("."),
						\'text': getline("."),
						\'line': getline(".")}]
		endwhile
	endfor

	bd

	return matches
endfunction

function! parainclude#dmatches(pattern)
	let filenames = parainclude#include_files()
	if &l:define != ''
		let define = &l:define
	else
		let define = &g:define
	endif

	tabnew|setlocal buftype=nofile bufhidden=delete noswapfile

	let matches=[]
	for filename in filenames
		%d
		call append(1, bufexists(filename) ? getbufline(filename, 1, "$") : readfile(filename))
		1d

		let flags='Wc'
		call cursor(0,0,0)
		while search(define, flags) != 0
			let flags='W'
			if getline(".") =~ &include
				continue
			endif
			let text = substitute(getline(".")[col(".")-1:], '\v^(\i*).*$','\1','')
			if text !~ a:pattern
				continue
			endif
			let matches += [{
						\ 'filename': filename,
						\ 'lnum': line("."),
						\ 'col': col("."),
						\ 'text': text,
						\ 'line': getline(".")}]
		endwhile
	endfor

	bd

	return matches
endfunction

function! parainclude#iqf(pattern)
	call setqflist(parainclude#imatches(a:pattern))
endfunction

function! parainclude#iloc(pattern)
	call setloclist(0,parainclude#imatches(a:pattern))
endfunction

function! parainclude#dqf(pattern)
	call setqflist(parainclude#dmatches(a:pattern))
endfunction

function! parainclude#dloc(pattern)
	call setloclist(0,parainclude#dmatches(a:pattern))
endfunction

function! s:count_to_index(count)
	if a:count == '$'
		let i = -1
	else
		let i = a:count-1
	endif
	return i
endfunction

function! parainclude#isearch(pattern, count)
	let matches = parainclude#imatches(a:pattern)
	let i = s:count_to_index(a:count)
	if len(matches)-1 < i
		echohl ErrorMsg
		echo "E389: Couldn't find pattern"
		echohl Normal
	elseif matches[i]['filename'] == expand("%:p") && matches[i]['lnum'] == line(".")
		echohl ErrorMsg
		echo "E387: Match is on current line"
		echohl Normal
	else
		redraw
		echo matches[i]['text']
	endif
endfunction

function! parainclude#dsearch(pattern, count)
	let matches = parainclude#dmatches(a:pattern)
	let i = s:count_to_index(a:count)
	if len(matches)-1 < i
		echohl ErrorMsg
		echo "E389: Couldn't find pattern"
		echohl Normal
	elseif matches[i]['filename'] == expand("%:p") && matches[i]['lnum'] == line(".")
		echohl ErrorMsg
		echo "E387: Match is on current line"
		echohl Normal
	else
		redraw
		echo matches[i]['line']
	endif
endfunction

function! s:digits(num)
	let num = a:num
	let digits = 1
	while num > 0
		let num = num / 10
		let digits += 1
	endwhile
	return digits
endfunction

function! s:indent(chars)
	if a:chars < 1
		return
	endif
	for char in range(1, a:chars)
		echon " "
	endfor
endfunction

function! parainclude#ilist(pattern)
	call s:xlist(a:pattern, 'i')
endfunction

function! parainclude#dlist(pattern)
	call s:xlist(a:pattern, 'd')
endfunction

function! s:xmatches(pattern, listtype)
	if a:listtype == 'i'
		let matches = parainclude#imatches(a:pattern)
	else
		let matches = parainclude#dmatches(a:pattern)
	endif
	return matches
endfunction

function! s:xlist(pattern, listtype)
	let i = 0
	let filename = ""
	let matches = s:xmatches(a:pattern, a:listtype)
	let max_index_digits = s:digits(len(matches))
	let max_lnum = 0
	for match in matches
		if match['lnum'] > max_lnum
			let max_lnum = match['lnum']
		endif
	endfor
	let max_lnum_digits = s:digits(max_lnum)
	for match in matches
		let i+=1
		if filename != match['filename']
			let filename = match['filename']
			echohl Comment
			echo filename
			echohl Normal
		endif
		echo ""
		call s:indent(max_index_digits - s:digits(i)+1)
		echon i . ":"
		call s:indent(max_lnum_digits - s:digits(match['lnum'])+2)
		echohl LineNr
		echon match['lnum']
		echohl Normal
		echon " "
		echon match['line']
	endfor
endfunction

function! parainclude#ijump(pattern, count)
	call s:xjump(a:pattern, a:count, 'i')
endfunction

function! parainclude#djump(pattern, count)
	call s:xjump(a:pattern, a:count, 'd')
endfunction

function! s:xjump(pattern, count, listtype)
	let matches = s:xmatches(a:pattern, a:listtype)
	let i = s:count_to_index(a:count)
	if len(matches)-1 < i
		echohl ErrorMsg
		echo "E389: Couldn't find pattern"
		echohl Normal
	elseif matches[i]['filename'] == expand("%:p") && matches[i]['lnum'] == line(".")
		echohl ErrorMsg
		echo "E387: Match is on current line"
		echohl Normal
	else
		let filename=matches[i]['filename']
		let lnum=matches[i]['lnum']
		let col=matches[i]['col']
		if !bufexists(filename)
			execute "e " . filename
		endif
		execute "b " . bufnr(filename)
		call setpos('.', [bufnr(filename), lnum, col, 0])
	endif
endfunction

function! parainclude#d_comp(A,L,P)
	if a:A == ''
		return []
	endif
	if !exists('s:cached_matches') || len(a:A) < len(s:prev_A)
		let s:cached_matches = parainclude#dmatches(a:A)
	endif
	let s:prev_A = a:A

	let results = []
	for match in s:cached_matches
		if match['text'] =~ a:A
			let results += [match['text']]
		endif
	endfor
	return results
endfunction
