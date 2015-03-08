" Compile
command! Make :call make#make()
" Do a check without compiling
command! Lint :call make#lint()

" Compile
nnoremap <space>m        :Make<cr>
" Do a check without compiling
nnoremap <space>l        :Lint<cr>
