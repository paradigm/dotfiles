" ==============================================================================
" = vim ftplugin                                                               =
" ==============================================================================

" open help page for word under cursor in preview window
nnoremap <buffer> K :execute ":help " . expand("<cword>") . " \| pedit % \| q"<cr>

" Vim has its own omnicompletion mapping by default, separate from the normal
" one. Set the normal omnicompletion mapping to cover the special VimL
" completion, as well as the custom ctrl-space.
inoremap <buffer> <c-x><c-o> <c-x><c-v>
inoremap <buffer> <c-@> <c-x><c-v>

" set where to store language-specific tags
let b:paratags_lang_tags = "~/.vim/tags/vimtags"
" set where to look for library
call paratags#langadd("~/.vimrc")
call paratags#langadd("~/.vim/")
