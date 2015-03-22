" have [i family operate on visually selected area

" The substitute() logic from SearchParty.  See:
" https://github.com/dahu/SearchParty.  Thanks, bairui.

xnoremap [i     "*y<esc>:isearch /<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr>/<cr>
xnoremap [I     "*y<esc>:ilist   /<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr>/<cr>
xnoremap [<c-i> "*y<esc>:ijump   /<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr>/<cr>
