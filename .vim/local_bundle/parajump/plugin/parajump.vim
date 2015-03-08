" ==============================================================================
" = parajump                                                                   =
" ==============================================================================
"
" Vertical jump across contiguous whitespace or non-whitespace.

nnoremap        <space>j :call parajump#run(1)<cr>
onoremap        <space>j :call parajump#run(1)<cr>
xnoremap <expr> <space>j       parajump#expr(1)
nnoremap        <space>k :call parajump#run(-1)<cr>
onoremap        <space>k :call parajump#run(-1)<cr>
xnoremap <expr> <space>k       parajump#expr(-1)
