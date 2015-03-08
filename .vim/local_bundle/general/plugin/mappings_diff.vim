" Turn on diffing for current window
nnoremap <c-p>t :diffthis<cr>
" Recalculate diffs
nnoremap <c-p>u :diffupdate<cr><c-l>
" Disable diffs
nnoremap <c-p>x :diffoff<cr>:sign unplace *<cr>
" Yank changes from other diff window
nnoremap <c-p>y do<cr>
" Paste changes into other diff window
nnoremap <c-p>p dp<cr>
