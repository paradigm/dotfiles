" Save session
nnoremap <c-k>w          :call session#save(0)<cr>
" Load session
nnoremap <c-k>l          :call session#load()<cr>

" Save session
command! -bang -bar -nargs=* SessionSave :call session#save("<bang>" == "!", <f-args>)
" Load session
command! -bar -nargs=* -complete=customlist,session#list SessionLoad :call session#load(<f-args>)
