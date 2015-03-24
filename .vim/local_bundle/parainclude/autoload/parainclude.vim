" get list of included files to parse
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

" Clone text of specified file.
"
" If file is already open in a buffer, use buffer, in case buffer has changes
" which were not saved.
function! s:clone_file(filename)
	%d
	call append(1, bufexists(a:filename) ? getbufline(a:filename, 1, "$") : readfile(a:filename))
	1d
endfunction

" Check if in comment
"
" Dependent on 'filetype', 'comments' being set and 'formatoptions' including
" "r".  Does not depend on syntax highlighting - feel free "set syntax=OFF".
"
" Fails in many situations, e.g. a C file with just "* foo" or shell file with
" just "#foo".
function! s:in_comment()
	let pos = getcurpos()
	execute "normal! A\<cr>"
	if getline(".") !~ '^\s*$'
		let in_comment = 1
	else
		let in_comment = 0
	endif
	d "_
	call setpos(".", pos)
	return in_comment
endfunction

function! parainclude#imatches(pattern)
	return s:xmatches(a:pattern, 'i')
endfunction

function! parainclude#dmatches(pattern)
	return s:xmatches(a:pattern, 'd')
endfunction

" Get all of the matches in all of the included files for the given pattern.
" If using 'define', limit to 'define' matches.  Supports newline in 'define'.
function! s:xmatches(pattern, listtype)
	" get list of files to parse
	let filenames = parainclude#include_files()
	" backup settings we'll need in the Scratch buffer
	if &l:filetype != ''
		let filetype = &l:filetype
	else
		let filetype = &g:filetype
	endif
	if &l:define != ''
		let define = &l:define
	else
		let define = &g:define
	endif
	if &l:include != ''
		let include = &l:include
	else
		let include = &g:include
	endif

	" create scratch buffer
	tabnew|setlocal buftype=nofile bufhidden=delete noswapfile

	" set required buffer-local settings for s:in_comment()
	let &l:filetype = filetype
	setlocal syntax=OFF
	setlocal formatoptions+=r

	" loop over files to find the pattern
	let matches = []
	for filename in filenames
		" get contents of file to parse
		call s:clone_file(filename)

		" start cursor in top-left
		call cursor(0,0,0)
		" only first match on cursor position
		let flags='Wc'
		" pattern to search for.  to support multi-line 'define',
		" search on define when 'define' is used
		if a:listtype == 'i'
			let searchbase = a:pattern
		else
			let searchbase = define
		endif
		while search(searchbase, flags) != 0
			" only first match on cursor position
			let flags='W'
			" if line is include line, no match
			if getline(".") =~ &include
				continue
			endif
			" if line is in comment, no match
			if s:in_comment()
				continue
			endif
			if a:listtype == 'd'
				" get actual text of match
				let text = substitute(getline(".")[col(".")-1:], '\v^(\i*).*$','\1','')
				" if 'define', we've only matched 'define' - not the
				" desired pattern.  Check for patttern.
				if text !~ a:pattern
					continue
				endif
			else
				let text = getline(".")
			endif
			" Found a match.  Append to matches.
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
	call setqflist(s:xmatches(a:pattern, 'i'))
endfunction

function! parainclude#iloc(pattern)
	call setloclist(0, s:xmatches(a:pattern, 'i'))
endfunction

function! parainclude#dqf(pattern)
	call setqflist(s:xmatches(a:pattern, 'd'))
endfunction

function! parainclude#dloc(pattern)
	call setloclist(0, s:xmatches(a:pattern, 'd'))
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
	call s:xsearch(a:pattern, a:count, 'i')
endfunction

function! parainclude#dsearch(pattern, count)
	call s:xsearch(a:pattern, a:count, 'd')
endfunction

function! s:xsearch(pattern, count, listtype)
	let matches = s:xmatches(a:pattern, a:listtype)
	let i = s:count_to_index(a:count)
	if len(matches)-1 < i
		redraw
		echohl ErrorMsg
		echo "E389: Couldn't find pattern"
		echohl Normal
	elseif matches[i]['filename'] == expand("%:p") && matches[i]['lnum'] == line(".")
		redraw
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

function! s:xlist(pattern, listtype)
	let i = 0
	let filename = ""
	let matches = s:xmatches(a:pattern, a:listtype)
	if len(matches) == 0
		redraw
		echohl ErrorMsg
		if a:listtype == 'i'
			echo "E389: Couldn't find pattern"
		else
			echo "E388: Couldn't find definition"
		endif
		echohl Normal
	endif
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
		redraw
		echohl ErrorMsg
		if a:listtype == 'i'
			echo "E389: Couldn't find pattern"
		else
			echo "E388: Couldn't find definition"
		endif
		echohl Normal
	elseif matches[i]['filename'] == expand("%:p") && matches[i]['lnum'] == line(".")
		redraw
		echohl ErrorMsg
		echo "E387: Match is on current line"
		echohl Normal
	else
		let filename=matches[i]['filename']
		let lnum=matches[i]['lnum']
		let col=matches[i]['col']
		if !bufexists(filename)
			" :e sets jumplist
			execute "e " . filename
			call setpos('.', [bufnr("%"), lnum, col, 0])
		elseif bufnr(filename) != bufnr("%")
			" :b sets jumplist
			execute "b " . bufnr(filename)
			call setpos('.', [bufnr("%"), lnum, col, 0])
		else
			" already in buffer, have search set jumplist
			execute "silent! keeppatterns normal! /\\%" . lnum . "l\\%" . col . "c\<cr>"
		endif
	endif
endfunction

function! parainclude#pijump(pattern, count)
	call s:xpdjump(a:pattern, a:count, 'i')
endfunction

function! parainclude#pdjump(pattern, count)
	call s:xpdjump(a:pattern, a:count, 'd')
endfunction

function! s:xpdjump(pattern, count, listtype)
	let g:parainclude_pattern = a:pattern
	let g:parainclude_count = a:count
	call preview#cmd("call parainclude#" . a:listtype . "jump(g:parainclude_pattern, g:parainclude_count)")
	unlet g:parainclude_pattern
	unlet g:parainclude_count
endfunction

" Cmdline-completion for 'define' items.
"
" Does not work in cmdline-window.
" TODO: maybe close cmdline-window, get matches, and re-open?  Search a
" variable instead of a buffer?
function! parainclude#d_cmdline_comp(A,L,P)
" 	if a:A == ''
" 		return []
" 	endif
	if !exists('s:cached_matches') || len(a:A) < len(s:prev_A)
		let s:cached_matches = s:xmatches(a:A, 'd')
	endif
	let s:prev_A = a:A

	let regex = glob2regex#conv(a:A)

	let results = []
	for match in s:cached_matches
		if match['text'] =~ regex
			let results += [match['text']]
		endif
	endfor
	return results
endfunction

" Setup omni-completion for 'define' items, set autocmds to restore
" user-completion
function! parainclude#d_ins_comp()
	let s:omnifunc=&l:omnifunc
	setlocal omnifunc=parainclude#d_user_comp

	let start=strlen(substitute(getline(".")[:col(".")], '\i*$','',''))
	let base=getline(".")[start : col(".")]

	let s:cached_matches = s:xmatches(base, 'd')

	augroup ParaInclude
		autocmd!
		autocmd CompleteDone * let &l:omnifunc=s:omnifunc | autocmd! ParaInclude
	augroup END
endfunction

" ins-completion for 'define' items based on cached values from
" parainclude#d_ins_comp()
function! parainclude#d_user_comp(findstart, base)
	if a:findstart == 1
		return strlen(substitute(getline(".")[:col(".")], '\i*$','',''))
	else
		return filter(map(s:cached_matches, 'v:val["text"]'), 'stridx(v:val, a:base) == 0')
	endif
endfunction
