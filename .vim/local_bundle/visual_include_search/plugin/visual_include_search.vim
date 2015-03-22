" have [I and [<c-i> operate on visually selected area

" The substitute() logic from SearchParty.  See:
" https://github.com/dahu/SearchParty.  Thanks, bairui.
xnoremap [I "*y<Esc>:ilist <c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr><esc>
xnoremap [<c-i> "*y<Esc>:ijump <c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr><esc>
