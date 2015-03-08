" ==============================================================================
" = mapop                                                                      =
" ==============================================================================

" Map a given input to a function, acting like an operator (e.g. supporting
" operator-pending mode)
function! custom_operators#load(key, func)
	" normal mode, normal use
	execute "nnoremap <silent> " . a:key .       " :set opfunc=" . a:func . "<cr>g@"
	" normal mode, double use (i.e. use on the current line)
	execute "nnoremap <silent> " . a:key . a:key " :set opfunc=" . a:func . "<cr>g@g@"
	" visual mode
	execute "xnoremap <silent> " . a:key .       " :<c-u>call "  . a:func . "(visualmode())<cr>"
endfunction

" There are two modes that need to be handled, and three possible types.
" Which of these six possibilities is indicated by the "a:type" argument:
"
" - "char"    (normal characterwise)
" - "line"    (normal linewise)
" - "block"   (normal blockwise)
" - "v"       (visual characterwise)
" - "V"       (visual linewise)
" - "\<c-v>"  (visual blockwise)
"
" Normal mode items have their region specified via the `[ and `] marks.
" Visual mode items have their region specified via the `< and `> marks.

" Returns useful data from a:type argument to simplify later functions.
function! <sid>components(type)
	if a:type == "char"
		return ["n", "v", "`[", "`]", "'[", "']"]
	elseif a:type == "line"
		return ["n", "V", "`[", "`]", "'[", "']"]
	elseif a:type == "block"
		return ["n", "\<c-v>", "`<", "`>", "'<", "'>"]
	else
		return ["v", a:type, "`<", "`>", "'<", "'>"]
	endif
endfunction

" Yank to system clipboards
function! custom_operators#system_yank(type)
	let [mode, wise, tickstart, tickend, quotestart, quoteend] = <sid>components(a:type)
	execute "normal! " . tickstart . "\"+y" . wise . tickend
	execute "normal! " . tickstart . "\"*y" . wise . tickend
endfunction

" Get contents described by range
function! custom_operators#get_range_content(type)
	let [mode, wise, tickstart, tickend, quotestart, quoteend] = <sid>components(a:type)
	let unnamedreg = @"
	execute "normal! " . tickstart . "\"+y" . wise . tickend
	let retval = @"
	let @" = unnamedreg
	return retval
endfunction

function! custom_operators#toggle_comment(type)
	let [mode, wise, tickstart, tickend, quotestart, quoteend] = <sid>components(a:type)

	let c = substitute(&commentstring,"%s","","")
	if c == "/**/"
		let c = "//"
	endif

	let toggle_on = 0
	for linenr in range(line(quotestart), line(quoteend))
		if getline(linenr) !~ "^" . c . " "
			let toggle_on = 1
			break
		endif
	endfor

	if toggle_on
		execute quotestart . "," . quoteend . "s,^," . c . " ,"
	else
		execute quotestart . "," . quoteend . "s,^" . c . " ,,e"
	endif
	nohlsearch
endfunction

" Filter through bc
function! custom_operators#filter_bc(type)
	silent! call custom_operators#filter(a:type, 'bc -l')
endfunction

" Filter through sage
function! custom_operators#filter_sage(type)
	silent! call custom_operators#filter(a:type, 'sage -q 2>/dev/null | head -n1 | cut -c7-')
endfunction

" Filter selected area through some cmdline command
function! custom_operators#filter(type, filter)
	let [mode, wise, tickstart, tickend, quotestart, quoteend] = <sid>components(a:type)

	" back up
	let starreg = @*

	" use wiserange to apply filter to range
	if wise ==# "v"
		execute "CW " . quotestart . "," . quoteend . "!" . a:filter
	elseif wise ==#"V"
		execute quotestart . "," . quoteend . "!" . a:filter
	elseif wise ==#"\<c-v>"
		execute "BW " . quotestart . "," . quoteend . "!" . a:filter
	endif

	" restore
	let @* = starreg
endfunction
