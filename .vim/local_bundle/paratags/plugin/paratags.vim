" Refresh tags for open buffers
command! ParaTagsBuffers     :call paratags#buffers()
" Refresh tags in non-relative entries in 'path'
command! ParaTagsPath        :call paratags#path()
" Add 'path' tags to 'tags'
command! ParaTagsEnable  :call paratags#path_enable()
" Remove 'path' tags from 'tags'
command! ParaTagsDisable :call paratags#path_disable()

" All of these will refresh the tags for the open buffers.
"
" Jump to tag, guessing if there are multiple matches
nnoremap <c-]>           :ParaTagsBuffers<cr><c-]>
" Jump to tag, listing options if there are multiple matches
nnoremap g<c-]>           :ParaTagsBuffers<cr>g<c-]>
" Show tag match in preview window
nnoremap <space>P        :ParaTagsBuffers<cr><c-w>}
