" In pop-up-menu, page down
" In insert mode, do buffer-only completion
inoremap <expr> <c-f> pumvisible() ?
			\ "\<pagedown>" :
			\ "\<c-o>:\<c-u>call custcomplete#run('.')\<cr>\<c-n>"
" In pop-up-menu, page down
" In insert mode, do buffer-only completion
inoremap <expr> <c-b> pumvisible() ?
			\ "\<pageup>" :
			\ "\<c-o>:\<c-u>call custcomplete#run('.')\<cr>\<c-p>"
" Have i_ctrl-<space> act like i_ctrl-x_ctrl-o. Note that ctrl-@ is triggered by
" ctrl-<space> in many terminals.
inoremap <c-@> <c-x><c-o>
" Have i_ctrl-l act like i_ctrl-x_ctrl-l.
inoremap <c-l> <c-x><c-l>
