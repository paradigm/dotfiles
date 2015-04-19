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
	setlocal formatoptions+=r
	let pos = getcurpos()
	execute "normal! A\<cr>"
	let in_comment = (getline(".") !~ '^\s*$')
	d "_
	call setpos(".", pos)
	return in_comment
endfunction

" returns a list of all of the matches for the given pattern in all of the
" included files.  If using 'define', limit to 'define' matches.  Supports
" newline in 'define'.
function! s:get_matches(pattern, listtype, skipcomments)
	" get files to search
	let filenames = parainclude#include_files()

	" backup settings we'll need in the Scratch buffer
	let filetype = &filetype
	let define = &define
	let include = &include

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
			if getline(".") =~ include
				continue
			endif
			" if line is in comment, no match
			if a:skipcomments && s:in_comment()
				continue
			endif
			if a:listtype == 'd'
				" get actual text of match
				" uses 'isident'
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

function! parainclude#search(pattern, listtype, count, bang)
	let matches = s:get_matches(a:pattern, a:listtype, !a:bang)

	let i = a:count - 1

	if len(matches) < a:count
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

function! parainclude#list(pattern, listtype, bang)
	let i = 0
	let filename = ""
	let matches = s:get_matches(a:pattern, a:listtype, !a:bang)

	if len(matches) == 0
		redraw
		echohl ErrorMsg
		if a:listtype == 'i'
			echo "E389: Couldn't find pattern"
		else
			echo "E388: Couldn't find definition"
		endif
		echohl Normal
		return
	endif

	" get number of characters wide some columns will be to format
	" properly
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
		" filename header
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

function! parainclude#jump(pattern, listtype, count, bang)
	let matches = s:get_matches(a:pattern, a:listtype, !a:bang)

	let i = a:count - 1

	if len(matches) < a:count
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
		elseif bufnr(filename) != bufnr("%")
			" :b sets jumplist
			execute "b " . bufnr(filename)
		else
			" already in buffer, have search set jumplist
			call support#push_jumplist()
		endif
		call setpos('.', [bufnr("%"), lnum, col, 0])
	endif
endfunction

function! parainclude#qf(pattern, listtype, bang)
	call setqflist(s:get_matches(a:pattern, a:listtype, !a:bang))
	call support#cc()
endfunction

function! parainclude#loc(pattern, listtype, bang)
	call setloclist(winnr(), s:get_matches(a:pattern, a:listtype, !a:bang))
	call support#ll()
endfunction

function! parainclude#preview(pattern, listtype, count, bang)
	let matches = s:get_matches(a:pattern, a:listtype, !a:bang)

	let i = a:count - 1

	if len(matches) < a:count
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
		execute "pedit! " . tempname()
		wincmd P
		setlocal buftype=nofile
		setlocal bufhidden=delete
		setlocal nobuflisted
		setlocal noswapfile

		let filename=matches[i]['filename']
		let lnum=matches[i]['lnum']
		let col=matches[i]['col']
		if !bufexists(filename)
			execute "e " . filename
		else
			execute "b " . bufnr(filename)
		endif
		call setpos('.', [bufnr("%"), lnum, col, 0])

		wincmd w
	endif
endfunction

" Setup omni-completion for 'define' items, set autocmds to restore
" user-completion
function! parainclude#d_ins_comp()
	let s:omnifunc=&l:omnifunc
	setlocal omnifunc=parainclude#d_omni_comp

	let start=strlen(substitute(getline(".")[:col(".")], '\i*$','',''))
	let base=getline(".")[start : col(".")]

	let s:cached_matches = s:get_matches(base, 'd', 0)

	augroup ParaInclude
		autocmd!
		autocmd CompleteDone * let &l:omnifunc=s:omnifunc | autocmd! ParaInclude
	augroup END
endfunction

" ins-completion for 'define' items based on cached values from
" parainclude#d_ins_comp()
function! parainclude#d_omni_comp(findstart, base)
	if a:findstart == 1
		return strlen(substitute(getline(".")[:col(".")], '\i*$','',''))
	else
		return filter(map(s:cached_matches, 'v:val["text"]'), 'stridx(v:val, a:base) == 0')
	endif
endfunction
