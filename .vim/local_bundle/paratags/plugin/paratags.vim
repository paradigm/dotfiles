if !exists("g:paratags_autorefresh")
	let g:paratags_autorefresh = {'buffers': 1, 'include': 1, 'git': 0, 'library': 0}
endif
if !exists("g:paratags_group")
	let g:paratags_group = 'include'
endif

command! -nargs=1 -complete=customlist,paratags#completegroups ParaTagsSetGroup :call paratags#setgroup(<q-args>)
command! ParaTagsAutoRefresh :call paratags#autorefresh()
command! ParaTagsManualRefresh :call paratags#manualrefresh()

" All of these will refresh the tags for the open buffers.
"
" Jump to tag, guessing if there are multiple matches
nnoremap <c-]>           :ParaTagsAutoRefresh<cr><c-]>
" Jump to tag, listing options if there are multiple matches
nnoremap g<c-]>          :ParaTagsAutoRefresh<cr>g<c-]>
" Show tag match in preview window
nnoremap <space>P        :ParaTagsAutoRefresh<cr><c-w>}

nnoremap <c-q>b :ParaTagsSetGroup buffers<cr>
nnoremap <c-q>i :ParaTagsSetGroup include<cr>
nnoremap <c-q>g :ParaTagsSetGroup git<cr>
nnoremap <c-q>l :ParaTagsSetGroup library<cr>
nnoremap <c-q>r :ParaTagsManualRefresh<cr>
