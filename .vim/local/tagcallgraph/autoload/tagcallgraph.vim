function! tagcallgraph#caller(...)
	call s:main('caller', a:000)
endfunction

function! tagcallgraph#callee(...)
	call s:main('callee', a:000)
endfunction

function! s:main(type, function_mask)
	" Using script-scoped to avoid constant passing.
	let s:tree = []
	let errormsg = s:get_functions()
	if errormsg == ""
		let filetype = s:get_filetype()
		call s:get_children(filetype)
		let s:pre_prune_tree = copy(s:tree)
		call s:prune(a:type)
	endif
	call s:render_window(a:type, errormsg, a:function_mask)
	redraw
	echo "TagCallGraph done"
endfunction

function! s:node_order(node1, node2)
	if a:node1['name'] > a:node2['name']
		return 1
	elseif a:node1['name'] < a:node2['name']
		return -1
	elseif a:node1['kind'] > a:node2['kind']
		return 1
	elseif a:node1['kind'] < a:node2['kind']
		return -1
	elseif a:node1['filename'] > a:node2['filename']
		return 1
	elseif a:node1['filename'] < a:node2['filename']
		return -1
	else
		return 0
	endif
endfunction

function! s:get_functions()
	redraw
	echo "TagCallGraph generation function list..."
	let s:tree = taglist('^')
	if s:tree == []
		return "** TAG FILE IS EMPTY **"
	endif
	" filter down to function - definitions and prototypes
	call filter(s:tree, 'v:val["kind"] == "f" || v:val["kind"] == "p"')
	if s:tree == []
		return "** TAG FILE HAS NO FUNCTIONS **"
	endif
	" Remove duplicates:
	" - If there is a function definition and prototype, drop prototype.
	" - If there is multiple prototypes in one file, drop all but one.
	call sort(s:tree, "s:node_order")
	let i = 0
	while i < len(s:tree)-1
		if s:tree[i]['name'] == s:tree[i+1]['name']
			if s:tree[i]['kind'] == 'f' && s:tree[i+1]['kind'] == 'p'
				unlet s:tree[i+1]
				let i-=1
			elseif s:tree[i]['kind'] == 'p' && s:tree[i+1]['kind'] == 'f'
				unlet s:tree[i]
				let i-=1
			elseif s:tree[i]['kind'] == 'p' && s:tree[i+1]['kind'] == 'p' && s:tree[i]['filename'] == s:tree[i+1]['filename']
				unlet s:tree[i+1]
				let i-=1
			endif
		endif
		let i+=1
	endwhile
	return ""
endfunction

function! s:get_filetype()
	redraw
	echo "TagCallGraph determining filetype..."
	if s:tree == []
		return ""
	endif

	if bufloaded(s:tree[0]['filename'])
		return getbufvar(s:tree[0]['filename'], "&filetype")
	endif

	augroup TagCallGraph
		autocmd!
		autocmd SwapExists * let v:swapchoice = 'o'
	augroup END
	execute "tabnew " . s:tree[0]['filename']
	autocmd! TagCallGraph
	let filetype = &filetype
	bd!
	return filetype
endfunction

function! s:go_to_definition_start(name, filetype, filename)
	if a:filetype == 'vim'
		if search('\v\s*fu%[nction]!?[^|]*<' . a:name . '\s*\zs\(', 'Wc') == 0
			return 0
		endif
	elseif a:filetype =~ '\vc|cpp|java|sh|bash|zsh|awk'
		if search('\v<' . a:name . '\(\zs', 'W') == 0
			return 0
		endif
	endif
	return 1
endfunction

function! s:go_to_definition_end(name, filetype, filename)
	if a:filetype == 'vim'
		if search('\v^\s*endfo@!%[unction]\zs', 'W') == 0
			return 0
		endif
	elseif a:filetype =~ '\vc|cpp|java|sh|bash|zsh|awk'
		if search('\v\zs\{', 'W') == 0
			return 0
		endif
		normal! %
		if getline(".")[col(".")-1] != '}'
			return 0
		endif
	endif
	return 1
endfunction

function! s:get_children(filetype)
	redraw
	echo "TagCallGraph generating call list..."
	tabnew|setlocal buftype=nofile bufhidden=delete noswapfile nonumber norelativenumber

	for i in range(0, len(s:tree)-1)
		let s:tree[i]['calls'] = []
		let s:tree[i]['lnum'] = -1

		if s:tree[i]['kind'] == 'p'
			continue
		endif

		silent %d
		call append(1, readfile(expand(s:tree[i]['filename'])))
		silent 1d

		" Jump to line containing function definition start.
		"
		" Tag cmd uses vi, not vim, default search
		if s:tree[i]['cmd'][0] == '/'
			execute 'keeppatterns /\M' . escape(s:tree[i]['cmd'][1:], '~[]')
		else
			execute 'keeppatterns ' . s:tree[i]['cmd']
		endif

		let s:tree[i]['lnum'] = line(".")

		" get exact function start and end
		if !s:go_to_definition_start(s:tree[i]['name'], a:filetype, s:tree[i]['filename'])
			let s:tree[i]['kind'] = 'p'
			continue
		endif
		let start = getcurpos()
		if !s:go_to_definition_end(s:tree[i]['name'], a:filetype, s:tree[i]['filename'])
			let s:tree[i]['kind'] = 'p'
			continue
		endif
		let end = getcurpos()

		" strip out everything that is not in the function definition
		if end[1] != line("$")
			execute 'silent! ' . end[1] . '+1,$ d "_'
		endif
		call setline(end[1], getline(end[1])[:end[2]-1])
		if start[1] != 1
			execute 'silent! 1,' . start[1] . '-1 d "_'
		endif
		if start[2] != 1
			call setline(1, getline(1)[start[2]-1:])
		endif

		" find function calls
		"
		" TODO: This assumes function call is just the name followed
		" by a (, which is not always true, e.g. comments.
		for node in s:tree
			if node['kind'] == 'p'
				continue
			endif
			call cursor(1,1,0)
			if search('\v<' . node['name'] . '\s*\(', 'Wc') != 0
				let s:tree[i]['calls'] += [node]
				" if there are multiple possible function
				" calls, do not report filename as we don't
				" know which
				if len(filter(copy(s:tree), 'v:val["name"] == node["name"]')) > 1
					let s:tree[i]['calls'][-1]['filenamel'] = ''
				endif
			endif
		endfor
	endfor

	bd!
endfunction

function! s:equate_nodes(node1, node2)
	return a:node1['name'] == a:node2['name'] && a:node1['filename'] == a:node2['filename']
endfunction

function! s:prune(type)
	redraw
	echo "TagCallGraph pruning tree..."
	let non_root_nodes = []
	if a:type == 'caller'
		for node in s:tree
			for child in node['calls']
				if index(non_root_nodes, child) != 0
					let non_root_nodes += [child]
				endif
			endfor
		endfor
	else
		for parent in s:tree
			if parent['calls'] != []
				if index(non_root_nodes, parent) != 0
					let non_root_nodes += [parent]
				endif
			endif
		endfor
	endif
	for non_root_node in non_root_nodes
		let i = 0
		while i < len(s:tree)-1
			if s:equate_nodes(s:tree[i], non_root_node)
				unlet s:tree[i]
			endif
			let i+=1
		endwhile
	endfor
endfunction

function! s:detect_recursion(node, used)
	for used_node in a:used
		if s:equate_nodes(used_node, a:node)
			return 1
		endif
	endfor
	return 0
endfunction

function! s:render_node(node, used)
	let output = ""
	for level in a:used
		let output .= '  '
	endfor
	let output .= a:node['name']
	if s:detect_recursion(a:node, a:used)
		let output .= ' (recursion)'
	endif
	if a:node['kind'] == 'p'
		let output .= ' (declaration)'
	endif
	if a:node['filename'] != ''
		let output .= ' (' . fnamemodify(a:node['filename'], ':t')
		if a:node['lnum'] != -1
			let output .= ':' . a:node['lnum']
		endif
		let output .= ')'
	else
		let output .= ' (multiple possible files)'
	endif
	call append('$', output)
endfunction

function! s:render_child(node, type, used)
	let used = copy(a:used)
	let used += [a:node]

	if a:type == 'caller'
		" recurse down to children
		for child in a:node['calls']
			call s:render_node(child, used)
			if !s:detect_recursion(child, used)
				call s:render_child(child, a:type, used)
			endif
		endfor
	else
		" recurse up to parents
		for parent in s:pre_prune_tree
			for parent_child in parent['calls']
				if s:equate_nodes(parent_child, a:node)
					call s:render_node(parent, used)
					if !s:detect_recursion(parent, used)
						call s:render_child(parent, a:type, used)
					endif
				endif
			endfor
		endfor
	endif
endfunction

function! s:render_window(type, errormsg, function_mask)
	redraw
	echo "TagCallGraph graphing and rendering..."
	" prepare window
	let tags=&tags
	if a:type == 'caller'
		let bufnrstr = 's:callerbufnr'
		if exists(bufnrstr)
			let bufnr = s:callerbufnr
		endif
	else
		let bufnrstr = 's:calleebufnr'
		if exists(bufnrstr)
			let bufnr = s:calleebufnr
		endif
	endif
	if !exists(bufnrstr) || !bufexists(bufnr)
		vsplit | enew | setlocal buftype=nofile nobuflisted noswapfile
		execute 'let ' . bufnrstr . ' = bufnr("%")'
	elseif bufwinnr(bufnr) == -1
		vsplit | enew | setlocal buftype=nofile bufhidden=delete nobuflisted noswapfile
		execute "b " . bufnr
		silent! %d
	else
		execute bufwinnr(bufnr) . "wincmd w"
		silent! %d
	endif
	let &l:tags=tags
	setlocal filetype=tagcallgraph

	if a:type == 'caller'
		call setline(1, '# Caller graph')
	else
		call setline(1, '# Callee graph')
	endif
	if a:errormsg == ""
		for node in s:tree
			if a:function_mask == [] || index(a:function_mask, node['name']) != -1
				call s:render_node(node, [])
				call s:render_child(node, a:type, [node])
			endif
		endfor
	else
		call append('$', a:errormsg)
	endif
	call s:setup_syntax()
endfunction

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
	highlight TagCallGraphRecursion ctermfg=Black ctermbg=Red
	highlight TagCallGraphDeclaration ctermfg=Red ctermbg=Black

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
	syntax match TagCallGraphDeclaration /(declaration)/
	syntax match Comment /([^)]*)$/
	syntax match ErrorMsg /^.. TAG FILE .*$/
	syntax match Comment /^# Calle[er] graph$/

	set foldmethod=indent
endfunction
