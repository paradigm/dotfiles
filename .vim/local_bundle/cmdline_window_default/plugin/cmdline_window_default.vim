" Swap default ':', '/' and '?' with cmdline-window equivalent.
execute "nnoremap : :" . &cedit . "a"
execute "xnoremap : :" . &cedit . "a"
execute "nnoremap / /" . &cedit . "a"
execute "xnoremap / /" . &cedit . "a"
execute "nnoremap ? ?" . &cedit . "a"
execute "xnoremap ? ?" . &cedit . "a"
nnoremap q: :
xnoremap q: :
nnoremap q/ /
xnoremap q/ /
nnoremap q? ?
xnoremap q? ?

" Have <esc> leave cmdline-window
autocmd CmdwinEnter * nnoremap <buffer> <esc> :q<cr>
