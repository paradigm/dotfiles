" There are two modes that need to be handled, and three possible types.
" Which of these six possibilities is indicated by the "a:type" argument:
"
" - "char"    (normal characterwise)
" - "line"    (normal linewise)
" - "block"   (normal blockwise)
" - "v"       (visual characterwise)
" - "V"       (visual linewise)
" - "\<c-v>"  (visual blockwise)

" Normal mode items have their region specified via the `[ and `] marks.
" Visual mode items have their region specified via the `< and `> marks.

" -----------------------------------------------------------------------------
" function to create new operators

function! operators#add(keys, func)
	" normal mode, normal use
	execute 'nnoremap <silent> <expr>' . a:keys . ' operators#expr("' . a:func . '", 0)'
	" normal mode, double use (i.e. use on the current line)
	execute 'nnoremap <silent> <expr>' . a:keys . a:keys . ' operators#expr("' . a:func . '", 1)'
	" visual mode
	execute "xnoremap <silent> " . a:keys .         " :<c-u>call "  . a:func . "(visualmode())<cr>"
endfunction

function! operators#expr(func, double)
	execute 'setlocal opfunc=' . a:func
	if a:double
		return 'g@g@'
	else
		return 'g@'
	endif
endfunction

" -----------------------------------------------------------------------------
" support functions to assist in creating new text objects

" Returns useful data from a:type argument to simplify creation of new
" operators
function! s:components(type)
	if a:type ==# "char"
		return ["n", "v", "`[", "`]", "'[", "']"]
	elseif a:type ==# "line"
		return ["n", "V", "`[", "`]", "'[", "']"]
	elseif a:type ==# "block"
		return ["n", "\<c-v>", "`<", "`>", "'<", "'>"]
	else
		return ["v", a:type, "`<", "`>", "'<", "'>"]
	endif
endfunction

" Filter selected area through some cmdline command
function! s:filter(type, filter)
	let [mode, wise, tickstart, tickend, quotestart, quoteend] = s:components(a:type)

	let starreg = @*

	" use wiserange to apply filter to range
	if wise is# "v"
		execute "CW " . quotestart . "," . quoteend . "!" . a:filter
	elseif wise is#"V"
		execute quotestart . "," . quoteend . "!" . a:filter
	elseif wise is#"\<c-v>"
		execute "BW " . quotestart . "," . quoteend . "!" . a:filter
	endif

	let @* = starreg
endfunction

" Returns contents described by the motion/object
function! operators#get_range_content(type)
	let [mode, wise, tickstart, tickend, quotestart, quoteend] = s:components(a:type)
	let unnamedreg = @"
	execute "silent normal! " . tickstart . "y" . wise . tickend
	let retval = @"
	let @" = unnamedreg
	return retval
endfunction

" -----------------------------------------------------------------------------
" operator to yank to both system clipboards

" Yank to system clipboards
function! operators#system_yank(type)
	let [mode, wise, tickstart, tickend, quotestart, quoteend] = s:components(a:type)
	execute "normal! " . tickstart . "\"+y" . wise . tickend
	execute "normal! " . tickstart . "\"*y" . wise . tickend
endfunction

" -----------------------------------------------------------------------------
" operator to toggle comments

function! operators#toggle_comment(type)
	let [mode, wise, tickstart, tickend, quotestart, quoteend] = s:components(a:type)

	let c = substitute(&commentstring,"%s","","")
	if c ==# "/**/"
		let c = "//"
	endif
	if c =~ ' $'
		let c = substitute(c, '\v +$', '', '')
	endif

	let toggle_on = 0
	for linenr in range(line(quotestart), line(quoteend))
		if getline(linenr) !~ "^" . c
			let toggle_on = 1
			break
		endif
	endfor

	if toggle_on
		execute 'silent 'quotestart . "," . quoteend . "s,^," . c . " ,"
	else
		execute 'silent 'quotestart . "," . quoteend . "s,^" . c . " ,,e"
	endif
	nohlsearch
endfunction

" -----------------------------------------------------------------------------
" operator to filter through bc

function! operators#filter_bc(type)
	silent! call s:filter(a:type, 'bc -l')
endfunction

" -----------------------------------------------------------------------------
" operator to filter through sage

function! operators#filter_sage(type)
	silent! call s:filter(a:type, 'sage -q 2>/dev/null | head -n1 | cut -c7-')
endfunction
