command! -nargs=+ DictionaryAdd call dictionary#dictionary_add(<q-args>)
command! -nargs=+ Define call dictionary#define(<q-args>)
command! -nargs=+ ThesaurusAdd call dictionary#thesaurus_add(<q-args>)
command! -nargs=+ Synonymize  call dictionary#synonymize(<q-args>)

" Thesaurus completion.  Grab entry on-the-fly if necessary
inoremap <c-x><c-t>      <c-o>:call dictionary#thesaurus_add(expand("<cword>"))<cr><c-x><c-t>
" Preview definitions
nnoremap g<c-d>          :<c-u>execute 'PreviewCmd Define ' . expand("<cword>")<cr>
xnoremap g<c-d>          "*y:execute 'PreviewCmd Define ' . substitute(@*, "\n", " ", "g")<cr>
" Preview synonyms
nnoremap g<c-t>          :<c-u>execute 'PreviewCmd Synonym ' . expand("<cword>")<cr>
xnoremap g<c-t>          "*y:execute 'PreviewCmd Synonym ' . substitute(@*, "\n", " ", "g")<cr>
