" Jump to <+jumppoint+>
command! SnippetJump :call snippet#jump()
" Accepts default snippet content
command! SnippetNext :call snippet#next()

" Jumps to next <++>.
inoremap <expr> <c-j> snippet#jump()
" Goes to next <++>
snoremap <expr> <c-j> snippet#next()
