" re-implementation of the include family of vim commands
"
" differences:
" - does not support [range]
" - ]-family of commands removed, replaced with new functionality
" - supports multi-line regex, both in the pattern and 'defin'e
" - cmdline command does not recognize [/] - only uses regex.  Add \<...\>
"   yourself
" - normal mode commands use \<...\>, visual mode do not
" - adds quickfix and loclist populating sets
" - adds preview jump
"
" The substitute() logic from SearchParty.  See:
" https://github.com/dahu/SearchParty.  Thanks, bairui.

command! -bang -count=1 -nargs=+ Isearch :call parainclude#search(<q-args>, 'i', <count>, "<bang>" == "!")
nnoremap <silent> [i :<c-u>Isearch <c-r>=v:count1 . ' \<' . expand("<cword>") . '\>'<cr><cr>
xnoremap <silent> [i :<c-u>Isearch <c-r>=v:count1 . ' ' . support#cmdline_arg(operators#get_range_content(visualmode()))<cr><cr>

command! -bang -count=1 -nargs=+ Dsearch :call parainclude#search(<q-args>, 'd', <count>, "<bang>" == "!")
nnoremap <silent> [d :<c-u>Dsearch <c-r>=v:count1 . ' \<' . expand("<cword>") . '\>'<cr><cr>
xnoremap <silent> [d :<c-u>Dsearch <c-r>=v:count1 . ' ' . support#cmdline_arg(operators#get_range_content(visualmode()))<cr><cr>

command! -bang -nargs=+ Ilist :call parainclude#list(<q-args>, 'i', "<bang>" == "!")
nnoremap <silent> [I :<c-u>Ilist <c-r>='\<' . expand("<cword>") . '\>'<cr><cr>
xnoremap <silent> [I :<c-u>Ilist <c-r>=support#cmdline_arg(operators#get_range_content(visualmode()))<cr><cr>

command! -bang -nargs=+ Dlist :call parainclude#list(<q-args>, 'd', "<bang>" == "!")
nnoremap <silent> [D :<c-u>Dlist <c-r>='\<' . expand("<cword>") . '\>'<cr><cr>
xnoremap <silent> [D :<c-u>Dlist <c-r>=support#cmdline_arg(operators#get_range_content(visualmode()))<cr><cr>

command! -bang -count=1 -nargs=+ Ijump :call parainclude#jump(<q-args>, 'i', <count>, "<bang>" == "!")
nnoremap <silent> [<c-i> :<c-u>Ijump <c-r>=v:count1 . ' \<' . expand("<cword>") . '\>'<cr><cr>
xnoremap <silent> [<c-i> :<c-u>Ijump <c-r>=v:count1 . ' ' . support#cmdline_arg(operators#get_range_content(visualmode()))<cr><cr>

command! -bang -count=1 -nargs=+ Djump :call parainclude#jump(<q-args>, 'd', <count>, "<bang>" == "!")
nnoremap <silent> [<c-d> :<c-u>Djump <c-r>=v:count1 . ' \<' . expand("<cword>") . '\>'<cr><cr>
xnoremap <silent> [<c-d> :<c-u>Djump <c-r>=v:count1 . ' ' . support#cmdline_arg(operators#get_range_content(visualmode()))<cr><cr>

command! -bang -nargs=+ Iqf :call parainclude#qf(<q-args>, 'i', "<bang>" == "!")
nnoremap <silent> ]i :<c-u>Iqf <c-r>='\<' . expand("<cword>") . '\>'<cr><cr>
xnoremap <silent> ]i :<c-u>Iqf <c-r>=support#cmdline_arg(operators#get_range_content(visualmode()))<cr><cr>

command! -bang -nargs=+ Dqf :call parainclude#qf(<q-args>, 'd', "<bang>" == "!")
nnoremap <silent> ]d :<c-u>Dqf <c-r>='\<' . expand("<cword>") . '\>'<cr><cr>
xnoremap <silent> ]d :<c-u>Dqf <c-r>=support#cmdline_arg(operators#get_range_content(visualmode()))<cr><cr>

command! -bang -nargs=+ Iloc :call parainclude#loc(<q-args>, 'i', "<bang>" == "!")
nnoremap <silent> ]I :<c-u>Iloc <c-r>='\<' . expand("<cword>") . '\>'<cr><cr>
xnoremap <silent> ]I :<c-u>Iloc <c-r>=support#cmdline_arg(operators#get_range_content(visualmode()))<cr><cr>

command! -bang -nargs=+ Dloc :call parainclude#loc(<q-args>, 'd', "<bang>" == "!")
nnoremap <silent> ]D :<c-u>Dloc <c-r>='\<' . expand("<cword>") . '\>'<cr><cr>
xnoremap <silent> ]D :<c-u>Dloc <c-r>=support#cmdline_arg(operators#get_range_content(visualmode()))<cr><cr>

command! -bang -count=1 -nargs=+ Ipreview :call parainclude#preview(<q-args>, 'i', <count>, "<bang>" == "!")
nnoremap <silent> ]<c-i> :<c-u>Ipreview <c-r>=v:count1 . ' \<' . expand("<cword>") . '\>'<cr><cr>
xnoremap <silent> ]<c-i> :<c-u>Ipreview <c-r>=v:count1 . ' ' . support#cmdline_arg(operators#get_range_content(visualmode()))<cr><cr>

command! -bang -count=1 -nargs=+ Dpreview :call parainclude#preview(<q-args>, 'd', <count>, "<bang>" == "!")
nnoremap <silent> ]<c-d> :<c-u>Dpreview <c-r>=v:count1 . ' \<' . expand("<cword>") . '\>'<cr><cr>
xnoremap <silent> ]<c-d> :<c-u>Dpreview <c-r>=v:count1 . ' ' . support#cmdline_arg(operators#get_range_content(visualmode()))<cr><cr>

inoremap <c-x><c-d>  <c-o>:call parainclude#d_ins_comp()<cr><c-x><c-o>
