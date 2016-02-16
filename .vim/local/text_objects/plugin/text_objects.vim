" Create new text objects for pairs of identical characters
let pairs = '0123456789'
let pairs .= '~!@#$%^&*-=_+'
let pairs .= '\|;:,./?'
for char in split(pairs,'\zs')
	if char == '|'
		let char = '\' . char
	endif
	call text_objects#add(char,  'normal!T' . char . 'vt' . char, 'normal!F' . char . 'vf' . char)
endfor

" Folding regions
" With syntax folding on, this very often does "the right thing"
"call text_objects#add('f', 'normal![zjV]zk', 'normal![zV]z')
call text_objects#add('f', 'exec b:sel_i_func', 'exec b:sel_a_func')

" Entire buffer
call text_objects#add("\<cr>", 'normal!VggoG', 'normal!VggoG')
xnoremap <silent> i<cr> :<c-u>normal!VggoG<cr>'
onoremap <silent> i<cr> :normal vi<c-v><cr><cr>
xnoremap <silent> a<cr> :<c-u>normal!VggoG<cr>'
onoremap <silent> a<cr> :normal va<c-v><cr><cr>

" Recently changed text
call text_objects#add('c', 'normal!`[v`]', 'normal!`[v`]')

" Recently visually selected text
xnoremap <silent> iv gv
onoremap <silent> iv :normal viv<cr>
xnoremap <silent> av gv
onoremap <silent> av :normal vav<cr>

" Lines which share character in col(".")
call text_objects#add('l', 'call text_objects#similar_column()', 'call text_objects#similar_column()\|normal! V')

" Indent
call text_objects#add('i', 'call text_objects#inner_indent()', 'call text_objects#around_indent()')
