nnoremap <silent> [i     :<c-u>call parainclude#isearch('\<' . expand("<cword>") . '\>', v:count1)<cr>
nnoremap <silent> [I     :<c-u>call parainclude#ilist('\<' . expand("<cword>") . '\>')<cr>
nnoremap <silent> [<c-i> :<c-u>call parainclude#ijump('\<' . expand("<cword>") . '\>', v:count1)<cr>
nnoremap <silent> ]i     :<c-u>call parainclude#iqf('\<' . expand("<cword>") . '\>')<cr>:call cconerror#qf()<cr>
nnoremap <silent> ]I     :<c-u>call parainclude#iloc('\<' . expand("<cword>") . '\>')<cr>:call cconerror#loc()<cr>
nnoremap <silent> ]<c-i> :<c-u>call parainclude#pijump('\<' . expand("<cword>") . '\>', v:count1)<cr>

nnoremap <silent> [d     :<c-u>call parainclude#dsearch('\<' . expand("<cword>") . '\>', v:count1)<cr>
nnoremap <silent> [D     :<c-u>call parainclude#dlist('\<' . expand("<cword>") . '\>')<cr>
nnoremap <silent> [<c-d> :<c-u>call parainclude#djump('\<' . expand("<cword>") . '\>', v:count1)<cr>
nnoremap <silent> ]d     :<c-u>call parainclude#dqf('\<' . expand("<cword>") . '\>')<cr>:call cconerror#qf()<cr>
nnoremap <silent> ]D     :<c-u>call parainclude#dloc('\<' . expand("<cword>") . '\>')<cr>:call cconerror#loc()<cr>
nnoremap <silent> ]<c-d> :<c-u>call parainclude#pdjump('\<' . expand("<cword>") . '\>', v:count1)<cr>

" The substitute() logic from SearchParty.  See:
" https://github.com/dahu/SearchParty.  Thanks, bairui.
xnoremap <silent> [i     "*y<esc>:Isearch \<<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr>\><cr>
xnoremap <silent> [I     "*y<esc>:Ilist   \<<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr>\><cr>
xnoremap <silent> [<c-i> "*y<esc>:Ijump   \<<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr>\><cr>
xnoremap <silent> ]i     "*y<esc>:Iqf     \<<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr>\><cr>
xnoremap <silent> ]I     "*y<esc>:Iloc    \<<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr>\><cr>
xnoremap <silent> [<c-i> "*y<esc>:Ipjump  \<<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr>\><cr>

xnoremap <silent> [d     "*y<esc>:Dsearch \<<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr>\><cr>
xnoremap <silent> [D     "*y<esc>:Dlist   \<<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr>\><cr>
xnoremap <silent> [<c-d> "*y<esc>:Djump   \<<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr>\><cr>
xnoremap <silent> ]d     "*y<esc>:Dqf     \<<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr>\><cr>
xnoremap <silent> ]D     "*y<esc>:Dloc    \<<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr>\><cr>
xnoremap <silent> [<c-d> "*y<esc>:Dpjump  \<<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr>\><cr>

command! -nargs=+ Isearch :call parainclude#isearch(<q-args>, 1)
command! -nargs=+ Ilist   :call parainclude#ilist(<q-args>)
command! -nargs=+ Ijump   :call parainclude#ijump(<q-args>, 1)
command! -nargs=+ Iqf     :call parainclude#iqf(<q-args>) | call cconerror#qf()
command! -nargs=+ Iloc    :call parainclude#iloc(<q-args>) | call cconerror#loc()
command! -nargs=+ Ipjump  :call parainclude#pijump(<q-args>, 1)

command! -nargs=+ -complete=customlist,parainclude#d_cmdline_comp Dsearch :call parainclude#dsearch(<q-args>, 1)
command! -nargs=+ -complete=customlist,parainclude#d_cmdline_comp Dlist   :call parainclude#dlist(<q-args>)
command! -nargs=+ -complete=customlist,parainclude#d_cmdline_comp Djump   :call parainclude#djump(<q-args>, 1)
command! -nargs=+ -complete=customlist,parainclude#d_cmdline_comp Dqf     :call parainclude#dqf(<q-args>) | call cconerror#qf()
command! -nargs=+ -complete=customlist,parainclude#d_cmdline_comp Dloc    :call parainclude#dloc(<q-args>) | call cconerror#loc()
command! -nargs=+ -complete=customlist,parainclude#d_cmdline_comp Dpjump   :call parainclude#pdjump(<q-args>, 1)

inoremap <c-x><c-d>  <esc>:call parainclude#d_ins_comp()<cr>:undojoin<cr>gi<c-x><c-o>
