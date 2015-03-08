" Set thesaurus file location
execute "set thesaurus=" . $HOME . '/.vim/thesaurus'
" Set dictionary file location
" Note that the last field is populated by non-words.  Ensure "spell" is
" placed before the def dictionary so it has a higher priority.
execute "set dictionary=spell," . $HOME . '/.vim/dictionary'

" All of these will perform look-ups as necessary
"
" Complete synonyms
inoremap <c-x><c-t>      <c-o>:call thesaurus#populate(expand("<cword>"))<cr><c-x><c-t>
" Preview synonyms
nnoremap g<c-t>          :call thesaurus#preview_synonyms(expand("<cword>"))<cr>
xnoremap g<c-t>       "*y:call thesaurus#preview_synonyms(substitute(@*, "\n", " ", "g"))<cr>
" Preview definitions
nnoremap g<c-d>          :call dictionary#preview_definition(expand("<cword>"))<cr>
xnoremap g<c-d>       "*y:call dictionary#preview_definition(substitute(@*, "\n", " ", "g"))<cr>
