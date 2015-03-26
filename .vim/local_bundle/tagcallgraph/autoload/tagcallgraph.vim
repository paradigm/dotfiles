function! s:setup_syntax()
	highlight TagCallGraphLevel1 ctermfg=Gray ctermbg=Black
	highlight TagCallGraphLevel2 ctermfg=Cyan ctermbg=Black
	highlight TagCallGraphLevel3 ctermfg=Green ctermbg=Black
	highlight TagCallGraphLevel4 ctermfg=Blue ctermbg=Black
	highlight TagCallGraphLevel5 ctermfg=Yellow ctermbg=Black
	highlight TagCallGraphLevel6 ctermfg=Magenta ctermbg=Black
	highlight TagCallGraphLevel7 ctermfg=DarkGray ctermbg=Black
	highlight TagCallGraphLevel8 ctermfg=DarkCyan ctermbg=Black
	highlight TagCallGraphLevel9 ctermfg=DarkGreen ctermbg=Black
	highlight TagCallGraphLevel10 ctermfg=DarkBlue ctermbg=Black
	highlight TagCallGraphLevel11 ctermfg=DarkYellow ctermbg=Black
	highlight TagCallGraphLevel12 ctermfg=DarkMagenta ctermbg=Black
	highlight TagCallGraphLevel13 ctermfg=White ctermbg=Black
	highlight TagCallGraphRecursion ctermfg=Red ctermbg=Black

	syntax match TagCallGraphLevel1  /^[^ ][^(]*/
	syntax match TagCallGraphLevel2  /^ \{2}[^(]*/
	syntax match TagCallGraphLevel3  /^ \{4}[^(]*/
	syntax match TagCallGraphLevel4  /^ \{6}[^(]*/
	syntax match TagCallGraphLevel5  /^ \{8}[^(]*/
	syntax match TagCallGraphLevel6  /^ \{10}[^(]*/
	syntax match TagCallGraphLevel7  /^ \{12}[^(]*/
	syntax match TagCallGraphLevel8  /^ \{14}[^(]*/
	syntax match TagCallGraphLevel9  /^ \{16}[^(]*/
	syntax match TagCallGraphLevel10 /^ \{18}[^(]*/
	syntax match TagCallGraphLevel11 /^ \{20}[^(]*/
	syntax match TagCallGraphLevel12 /^ \{22}[^(]*/
	syntax match TagCallGraphLevel13 /^ \{24}[^(]*/

	syntax match TagCallGraphRecursion /(recursion)/
	syntax match Comment /([^)]*)$/
	syntax match ErrorMsg /^.. TAG FILE IS EMPTY ..$/
	syntax match Comment /^# Calle[er] graph$/
endfunction

function! tagcallgraph#caller()
	call s:run('caller')
endfunction

function! tagcallgraph#callee()
	call s:run('callee')
endfunction

function! s:run(type)
	call s:generate_tag_list()
	let tags=&tags
	if a:type == 'caller'
		if !exists("s:callerbufnr") || !bufexists(s:callerbufnr)
			vsplit | enew | setlocal buftype=nofile nobuflisted noswapfile
			let s:callerbufnr = bufnr("%")
		elseif bufwinnr(s:callerbufnr) == -1
			vsplit
			execute "b " . s:callerbufnr
			silent! %d
		else
			execute bufwinnr(s:callerbufnr) . "wincmd w"
			silent! %d
		endif
	else
		if !exists("s:calleebufnr") || !bufexists(s:calleebufnr)
			vsplit | enew | setlocal buftype=nofile nobuflisted noswapfile
			let s:calleebufnr = bufnr("%")
		elseif bufwinnr(s:calleebufnr) == -1
			vsplit
			execute "b " . s:calleebufnr
			silent! %d
		else
			execute bufwinnr(s:calleebufnr) . "wincmd w"
			silent! %d
		endif
	endif

	for tag in s:tags
		if a:type == 'caller'
			call s:append_callees(tag, [])
			call setline(1, '# Caller graph')
		else
			call s:append_callers(tag, [])
			call setline(1, '# Callee graph')
		endif
	endfor
	let max = 0
	g/^/ if len(getline(".")) > max | let max = len(getline(".")) | endif
	execute "vertical resize " . max+10
	call s:setup_syntax()
	keepalt wincmd w
endfunction

function! s:go_to_end_of_function(filetype)
	if a:filetype == 'vim'
		call search('^\_s\*endfun\%[ction]','W')
		return
	elseif a:filetype =~ '\vc|cpp|java|sh|bash|zsh|awk'
		call search('{','W')
		normal! %
		return
	endif
endfunction

function! s:append_callees(tag, used)
	" get indentation level from number of items we've hit
	let indent = ''
	for level in a:used
		let indent .= '  '
	endfor
	" check if calling something we've hit to avoid infinite recursion
	if index(a:used, a:tag["name"]) != -1
		call append('$', indent . a:tag["name"] . " (recursion) (" . fnamemodify(a:tag["filename"], ":t") . ")")
		return
	endif
	" append specified function
	call append('$', indent . a:tag["name"] . " (" . fnamemodify(a:tag["filename"], ":t") . ")")

	" recurse down to children
	let used = a:used + [a:tag["name"]]
	for child in a:tag['calls']
		for tag in s:tags
			if tag['name'] == child
				call s:append_callees(tag, used)
				break
			endif
		endfor
	endfor
endfunction

function! s:append_callers(tag, used)
	" get indentation level from number of items we've hit
	let indent = ''
	for level in a:used
		let indent .= '  '
	endfor
	" check if calling something we've hit to avoid infinite recursion
	if index(a:used, a:tag["name"]) != -1
		call append('$', indent . a:tag["name"] . " (recursion) (" . fnamemodify(a:tag["filename"], ":t") . ")")
		return
	endif
	" append specified function
	call append('$', indent . a:tag["name"] . " (" . fnamemodify(a:tag["filename"], ":t") . ")")

	" recurse up to parents
	let used = a:used + [a:tag["name"]]
	for tag in s:tags
		if index(tag['calls'], a:tag['name']) > -1
			call s:append_callers(tag, used)
		endif
	endfor
endfunction

function! s:generate_tag_list()
	" backup filetype
	let filetype = &filetype

	" get a list of all tags
	let s:tags = taglist('^')
	if s:tags == []
		let s:tags = [{'name': '** TAG FILE IS EMPTY **', 'calls': []}]
		return
	endif
	" filter list down to just functions
	call filter(s:tags, 'v:val["kind"] == "f"')
	if s:tags == []
		let s:tags = [{'name': '** TAG FILE HAS NO FUNCTIONS **', 'calls': []}]
		return
	endif
	" pull out a list of function names for quick access
	let function_names = map(copy(s:tags), 'v:val["name"]')

	" scratch location
	tabnew|setlocal buftype=nofile bufhidden=delete noswapfile

	" will need for tag["cmd"]'s to work
	setlocal nomagic

	" iterate over tags to find all the functions they call
	for i in range(0,len(s:tags)-1)
		let filename = s:tags[i]['filename']
		let cmd = s:tags[i]['cmd']
		let name = s:tags[i]['name']

		" copy file containing buffer into scratch location
		silent %d
		call append(1, bufexists(filename) ? getbufline(filename, 1, "$") : readfile(filename))
		silent 1d

		" run cmd to jump to tag
		execute "keeppatterns " . cmd

		" remove everything not needed
		" TODO: this assumes function start and end on lines that do
		" not call other functinos
		if line('.') != 1
			silent 1,.-1d
		endif
		call search(name, 'Wc')
		call s:go_to_end_of_function(filetype)
		if line('.') != line('$')
			silent .,$d
		endif
		silent 1d

		" search region for calls to a function
		" TODO: assumes function call is tag['name'] followed by a
		" "(".  Is this always true?
		let s:tags[i]['calls'] = []
		for function_name in function_names
			call cursor(1,1,0)
			if search(function_name . '\s\*(', 'Wc') != 0
				let s:tags[i]['calls'] += [function_name]
			endif
		endfor
	endfor

	" remove scratch buffer
	bd
endfunction
