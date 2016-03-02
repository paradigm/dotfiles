" Create new text objects for pairs of identical characters
let pairs = '0123456789'
let pairs .= '~!@#$%^&*-=_+'
let pairs .= '\|;:,./?'
for char in split(pairs,'\zs')
	if char == '|'
		let char = '\' . char
	endif
	call text_objects#add('i'     . char,  'normal!T' . char . 'vt' . char, 'default')
	call text_objects#add('a'     . char,  'normal!F' . char . 'vf' . char, 'default')
	call text_objects#add('<c-i>' . char,  'normal!T' . char . 'vf' . char, 'default')
endfor

" Folding regions
" With syntax folding on, this very often does "the right thing"
call text_objects#add('iF', 'normal![zjV]zk', 'V')
call text_objects#add('aF', 'normal![zV]z',   'V')

" Functions
call text_objects#add('if', 'call function(b:sel_i_func)()', 'V')
call text_objects#add('af', 'call function(b:sel_a_func)()', 'V')

" Entire buffer
call text_objects#add("i\<cr>", 'normal!VggoG', 'V')
call text_objects#add("a\<cr>", 'normal!VggoG', 'V')

" Recently changed text
call text_objects#add('ic', 'normal!`[v`]', 'default')
call text_objects#add('ac', 'normal!`[v`]', 'default')

" Recently visually selected text
xnoremap <silent> iv gv
onoremap <silent> iv :normal viv<cr>
xnoremap <silent> av gv
onoremap <silent> av :normal vav<cr>

" Lines which share character in col(".")
call text_objects#add('il', 'call text_objects#similar_column()', "\\<lt>c-v>")
call text_objects#add('al', 'call text_objects#similar_column()', "V")

" Indent
call text_objects#add('ii', 'call text_objects#inner_indent()', 'V')
call text_objects#add('ai', 'call text_objects#around_indent()', 'V')
