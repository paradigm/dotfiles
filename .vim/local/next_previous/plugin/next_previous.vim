" Find next/previous search item which is not visible in the window.
" Note that 'scrolloff' probably breaks this.
nnoremap <space>n L$nzt
nnoremap <space>N H$Nzb
" next/previous/first/last diff change
"nnoremap ]c ]c " this is already default
"nnoremap [c [c " this is already default
nnoremap [C :call next_previous#do_while('normal! [c', 'getcurpos()', '1')<cr>
nnoremap ]C :call next_previous#do_while('normal! ]c', 'getcurpos()', '1')<cr>
" next/previous/first/last buffer
nnoremap ]b :bnext<cr>
nnoremap [b :bprevious<cr>
nnoremap [B :bfirst<cr>
nnoremap ]B :blast<cr>
" next/previous/first/last tag
nnoremap ]t :PTAuto<cr>:tnext<cr>
nnoremap [t :PTAuto<cr>:tprevious<cr>
nnoremap [T :PTAuto<cr>:tfirst<cr>
nnoremap ]T :PTAuto<cr>:tlast<cr>
" next/previous/first/last/prevbuf/nextbuf quickfix item
nnoremap ]q :cnext<cr>
nnoremap [q :cprevious<cr>
nnoremap [Q :cfirst<cr>
nnoremap ]Q :clast<cr>
nnoremap [<c-q> :call next_previous#do_while('silent! cprev', 'getcurpos()', 'bufnr("%")') \| cc<cr>
nnoremap ]<c-q> :call next_previous#do_while('silent! cnext', 'getcurpos()', 'bufnr("%")') \| cc<cr>
" next/previous/first/last location list item
nnoremap ]l :lnext<cr>
nnoremap [l :lprevious<cr>
nnoremap [L :lfirst<cr>
nnoremap ]L :llast<cr>
nnoremap [<c-l> :call next_previous#do_while('silent! lprev', 'getcurpos()', 'bufnr("%")') \| ll<cr>
nnoremap ]<c-l> :call next_previous#do_while('silent! lnext', 'getcurpos()', 'bufnr("%")') \| ll<cr>
" next/previous/first/last argument list item
nnoremap ]a :next<cr>
nnoremap [a :previous<cr>
nnoremap [A :first<cr>
nnoremap ]A :last<cr>
" next/previous/first/last/first-include/last-include 'define' match
nnoremap [e :call support#push_jumplist()<cr>:call search(&define, 'bW')<cr>
nnoremap ]e :call support#push_jumplist()<cr>:call search(&define, 'W')<cr>
" TODO
" nnoremap [E :call support#push_jumplist()<cr>:call whilepos#change(":call search(&define, 'Wb')\<lt>cr>",1,1,1,1)<cr>
" nnoremap ]E :call support#push_jumplist()<cr>:call whilepos#change(":call search(&define, 'W')\<lt>cr>",1,1,1,1)<cr>
" nnoremap [<c-e> :call parainclude#djump('.',1)<cr>
" nnoremap ]<c-e> :call parainclude#djump('.','$')<cr>
" next/previous file from jump history
nnoremap [f :call next_previous#do_while("normal! \<lt>c-o>", 'getcurpos()', 'bufnr("%")')<cr>
" <esc> is used to indicate the end of the whitespace separation after a
" :normal in the function call
nnoremap ]f :call next_previous#do_while("normal! 1\<lt>c-i>", 'getcurpos()', 'bufnr("%")')<cr>
