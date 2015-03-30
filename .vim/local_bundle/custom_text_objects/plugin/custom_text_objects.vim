" Create new text objects for pairs of identical characters
let pairs = '0123456789'
let pairs .= '~!@#$%^&*-=_+'
let pairs .= '\|;:,./?'
let pairs .= '$,./-='
for char in split(pairs,'\zs')
	if char == '|'
		let char = '\' . char
	endif
	exec 'xnoremap i' . char . ' :<c-u>silent!normal!T' . char . 'vt' . char . '<cr>'
	exec 'onoremap i' . char . ' :normal vi' . char . '<CR>'
	exec 'xnoremap a' . char . ' :<c-u>silent!normal!F' . char . 'vf' . char . '<cr>'
	exec 'onoremap a' . char . ' :normal va' . char . '<CR>'
endfor

" Folding regions
" With syntax folding on, this very often does "the right thing"
xnoremap if :<c-u>silent!normal![zjV]zk<CR>
onoremap if :normal Vif<cr>
xnoremap af :<c-u>silent!normal![zV]z<CR>
onoremap af :normal Vaf<cr>

" Entire buffer
xnoremap i<cr> :<c-u>silent!normal!ggVG<cr>
onoremap i<cr> :normal Vi<c-v><cr><cr>
xnoremap a<cr> :<c-u>silent!normal!ggVG<cr>
onoremap a<cr> :normal Vi<c-v><cr><cr>

" Recently changed text
xnoremap ic :<c-u>silent!normal!`[v`]<CR>
onoremap ic :normal vic<cr>
xnoremap ac :<c-u>silent!normal!`[v`]<CR>
onoremap ac :normal vac<cr>

" Recently visually selected text
xnoremap iv gv
onoremap iv :normal viv<cr>
xnoremap av gv
onoremap av :normal vav<cr>

" Lines which share character in col(".")
xnoremap il :<c-u>silent! call selectsamelines#run("\<lt>c-v>")<cr>
onoremap il :normal vil<cr>
xnoremap al :<c-u>silent! call selectsamelines#run("V")<cr>
onoremap al :normal val<cr>

" Indent
xnoremap ii :<c-u>call select_indent#inner()<cr>
onoremap ii :normal vii<cr>
xnoremap ai :<c-u>call select_indent#extern()<cr>
onoremap ai :normal vai<cr>
