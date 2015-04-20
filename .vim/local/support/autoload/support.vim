" -----------------------------------------------------------------------------
" convert glob expression to regex

function! support#glob2regex(glob)
	let regex = '\V' . escape(a:glob,'/\')
	let regex = substitute(regex, '\V*', '\\.\\*', 'g')
	return regex
endfunction

" -----------------------------------------------------------------------------
" apply retab to string

function! support#retab(line)
	" make scratch buffer to apply retab to
	new|setlocal buftype=nofile bufhidden=delete noswapfile
	setlocal expandtab

	" retab
	call setline(1, a:line)
	retab

	" save line
	let new_line = getline(1)

	" close scratch window
	noautocmd q

	return new_line
endfunction

" -----------------------------------------------------------------------------
" push current position onto jumplist

function! support#push_jumplist()
	execute 'silent! keeppatterns normal! /\%' . line('.') . 'l\%' . col('.') . "c\<cr>"
endfunction

" -----------------------------------------------------------------------------
" custom location stack

function! support#push_stack(...)
	if a:0 == 0
		let name = 'default'
	else
		let name = a:1
	endif
	if !exists("g:stack")
		let g:stack = {}
	endif
	if !has_key(g:stack, name)
		let g:stack[name] = []
	endif
	let g:stack[name] += [[expand("%"), bufnr("%"), getcurpos()]]
endfunction

function! support#pop_stack(...)
	if a:0 == 0
		let name = 'default'
	else
		let name = a:1
	endif
	if !exists("g:stack") || !has_key(g:stack, name) || len(g:stack[name]) == 0
		redraw
		echohl ErrorMsg
		echo "E73: stack empty"
		echohl None
		return
	endif
	if bufnr(g:stack[name][-1][0]) ==# g:stack[name][-1][1]
		execute "b " . g:stack[name][-1][1]
	else
		execute "e " . g:stack[name][-1][0]
	endif
	call setpos(".", g:stack[name][-1][2])
	let g:stack[name] = g:stack[name][:-2]
endfunction

" -----------------------------------------------------------------------------
" Run a :cc or :ll without risking killing a script if there are no matches

function! support#cc()
	try
		cc
	catch
		echo 'no errors/results'
	endtry
endfunction
function! support#ll()
	try
		ll
	catch
		echo 'no errors/results'
	endtry
endfunction

" -----------------------------------------------------------------------------
" prepares string for use as cmdline argument
"
" The substitute() logic from SearchParty.  See:
" https://github.com/dahu/SearchParty.  Thanks, bairui.

function! support#cmdline_arg(string)
	return substitute(escape(a:string, '\/.*$^~[]'), "\n", '\\n', "g")
endfunction
