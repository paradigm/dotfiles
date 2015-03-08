" Load session
nnoremap <c-k>w          :call session#save()<cr>
" Save session
nnoremap <c-k>l          :call session#load()<cr>

" Save session
command! -nargs=1 SessionSave :call session#save(<f-args>)
" Load session
command! -nargs=1 -complete=customlist,session#list SessionLoad :call session#load(<f-args>)
