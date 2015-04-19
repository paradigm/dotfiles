" Compile
command! Make :call make#make()
" Do a check without compiling
command! Lint :call make#lint()

" Compile
nnoremap <space>m :Make<cr>
" Lint
nnoremap <space>l :Lint<cr>
