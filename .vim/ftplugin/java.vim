" ==============================================================================
" = java ftplugin                                                              =
" ==============================================================================

" TODO: test for eclim

" Due to newline matching, does not work with built-in 'define' functionality;
" requires specialized versions.
setlocal define=\\v(^\|;)\\s*(\\w+\\_s+)+\\zs\\ze\\w+\\_s*\\(\\_[^)]*\\)(\\_[^;]*\\{\|;)


let l:project = eclim#project#util#GetCurrentProjectName()
let b:runcmd = "eclim -editor vim -command java -p " . l:project

" Open documentation in preview window
nnoremap <buffer> K :JavaDocPreview<cr>
" eclim uses i_ctrl-x_ctrl-u rather than i_ctrl-x_ctrl-o
inoremap <buffer> <c-@> <c-x><c-u>
inoremap <buffer> <c-x><c-o> <c-x><c-u>
" launch eclim
nnoremap <buffer> <space>o :silent execute "!xterm -e eclimd &"<cr>
" jump to declaration/definition
nnoremap <buffer> <c-]> :call support#push_stack()<cr>:JavaSearchContext<cr>:autocmd! eclim_show_error<cr>
" pop tag stack
nnoremap <buffer> <c-t>        :call support#pop_stack()<cr>
" preview declaration
nnoremap <buffer> <space>P :normal mP<cr>:pedit!<cr>:wincmd w<cr>:normal `P<cr>:JavaSearchContext<cr>:autocmd! eclim_show_error<cr>:wincmd w<cr>
" preview declaration line
nnoremap <buffer> <space><c-p> :call preview#jump("JavaSearchContext", '!')<cr>

" 		" assumes eclim
" 		call eclim#lang#UpdateSrcFile('java',1) " have eclim populate loclist
" 		let g:EclimJavaValidate = 0             " disable auto-check
" 		" ensure auto-check disabled
" 		autocmd! eclim_java
" 		" ensure pop-up error explanation disabled
" 		autocmd! eclim_show_error
" 		call setqflist(getloclist(0))           " transfer loclist into qflist
" 		call cconerror#qf()
" 		return
