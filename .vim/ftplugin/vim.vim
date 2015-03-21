" ==============================================================================
" = vim ftplugin                                                               =
" ==============================================================================

" have [i and friends follow :source
setlocal include=^\\s*\\<source\\>

setlocal path+=~/.vimrc,~/.vim

" open help page for word under cursor in preview window
nnoremap <buffer> K :execute ":help " . expand("<cword>") . " \| pedit % \| q"<cr>

" Vim has its own omnicompletion mapping by default, separate from the normal
" one. Set the normal omnicompletion mapping to cover the special VimL
" completion, as well as the custom ctrl-space.
inoremap <buffer> <c-x><c-o> <c-x><c-v>
inoremap <buffer> <c-@> <c-x><c-v>

" Remove the "=" and "," characters from consideration for a file path when
" using things such as `gf`.  This is useful to follow file paths provided to
" Vim variables and settings.
set isfname -==
set isfname -=,
