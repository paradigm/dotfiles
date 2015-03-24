" Find next/previous search item which is not visible in the window.
" Note that 'scrolloff' probably breaks this.
nnoremap <space>n L$nzt
nnoremap <space>N H$Nzb
" next/previous/first/last diff change
"nnoremap ]c ]c " this is already default
"nnoremap [c [c " this is already default
nnoremap [C :call whilepos#change("[c",1,1,1,1)<cr>
nnoremap ]C :call whilepos#change("]c",1,1,1,1)<cr>
" next/previous/first/last buffer
nnoremap ]b :bnext<cr>
nnoremap [b :bprevious<cr>
nnoremap [B :bfirst<cr>
nnoremap ]B :blast<cr>
" next/previous/first/last tag
nnoremap ]t :tnext<cr>
nnoremap [t :tprevious<cr>
nnoremap [T :tfirst<cr>
nnoremap ]T :tlast<cr>
" next/previous/first/last/prevbuf/nextbuf quickfix item
nnoremap ]q :cnext<cr>
nnoremap [q :cprevious<cr>
nnoremap [Q :cfirst<cr>
nnoremap ]Q :clast<cr>
nnoremap [<c-q> :call whilepos#same(":silent! cprev\<lt>cr>",1,0,0,0)<cr>
nnoremap ]<c-q> :call whilepos#same(":silent! cnext\<lt>cr>",1,0,0,0)<cr>
" next/previous/first/last location list item
nnoremap ]l :lnext<cr>
nnoremap [l :lprevious<cr>
nnoremap [L :lfirst<cr>
nnoremap ]L :llast<cr>
nnoremap [<c-l> :call whilepos#same(":silent! lprev\<lt>cr>",1,0,0,0)<cr>
nnoremap ]<c-l> :call whilepos#same(":silent! lnext\<lt>cr>",1,0,0,0)<cr>
" next/previous/first/last argument list item
nnoremap ]a :next<cr>
nnoremap [a :previous<cr>
nnoremap [A :first<cr>
nnoremap ]A :last<cr>
" next/previous/first/last/first-include/last-include 'define' match
nnoremap [e :call forcejump#run()<cr>:call search(&define, 'bW')<cr>
nnoremap ]e :call forcejump#run()<cr>:call search(&define, 'W')<cr>
nnoremap [E :call forcejump#run()<cr>:call whilepos#change(":call search(&define, 'Wb')\<lt>cr>",1,1,1,1)<cr>
nnoremap ]E :call forcejump#run()<cr>:call whilepos#change(":call search(&define, 'W')\<lt>cr>",1,1,1,1)<cr>
nnoremap [<c-e> :call parainclude#djump('.',1)<cr>
nnoremap ]<c-e> :call parainclude#djump('.','$')<cr>
" next/previous file from jump history
nnoremap [f :call whilepos#same("\<lt>c-o>",1,0,0,0)<cr>
" <esc> is used to indicate the end of the whitespace separation after a
" :normal in the function call
nnoremap ]f :call whilepos#same("\<lt>esc>\<lt>c-i>",1,0,0,0)<cr>
