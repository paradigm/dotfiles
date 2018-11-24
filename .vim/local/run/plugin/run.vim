" Run
command! -nargs=* -complete=customlist,run#complete Run :call run#run('<args>')

" Run
nnoremap <space>r        :Run sh<cr>
" Run and put output in a preview window (assumes non-interactive)
nnoremap <space>R        :Run preview<cr>:wincmd p<cr>
" Run in an xterm
nnoremap <space><c-r>    :Run xterm<cr>
