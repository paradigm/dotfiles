" ==============================================================================
" = parajump                                                                   =
" ==============================================================================
"
" Vertical jump across contiguous whitespace or non-whitespace.

nnoremap <space>j :      call parajump#n(1)<cr>
onoremap <space>j :      call parajump#n(1)<cr>
xnoremap <space>j :<c-u> call parajump#v(1)<cr>
nnoremap <space>k :      call parajump#n(-1)<cr>
onoremap <space>k :      call parajump#n(-1)<cr>
xnoremap <space>k :<c-u> call parajump#v(-1)<cr>
