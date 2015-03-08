" Many of these were either shamelessly stolen from or inspired by
" SearchParty.  See: https://github.com/dahu/SearchParty.  Thanks, bairui.
"
" Having v_* and v_# search for visually selected area.
xnoremap * "*y<Esc>/<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr><cr>
xnoremap # "*y<Esc>?<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr><cr>
" Prepare search based on visually-selected area.  Useful for searching for
" something slightly different from something by the cursor.  For example, if
" on "xnoremap" and looking for "nnoremap"
xnoremap / "*y<Esc>q/i<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr><esc>0
" Prepare substitution based on visually-selected area.
xnoremap ? "*y<Esc>q:i%s/<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr>/
