" Enable fuzzing in skybison
"let g:skybison_fuzz = 2

" Switch from normal cmdline to SkyBison
cnoremap <c-l>     <c-\>eskybison#cmdline_switch()<cr><cr>
autocmd CmdwinEnter * let b:cmdline_window_running = 1

" Settings for skybison window
autocmd Filetype skybison inoremap <buffer> <silent> <c-c> <esc>:call skybison#quit()<cr>
autocmd Filetype skybison nnoremap <buffer> <silent> <c-c> :call skybison#quit()<cr>
autocmd Filetype skybison nnoremap <buffer> <silent> <esc> :call skybison#quit()<cr>

" General SkyBison prompt
nnoremap <space>; :<c-u>call skybison#run()<cr>
" SkyBison prompt for buffers
nnoremap <cr>     :<c-u>call skybison#run("b ", 2)<cr>
" (re)generate local tags then have SkyBison prompt for tags
nnoremap <bs>      :<c-u>ParaTagsBuffers<cr>2:<c-u>call skybison#run("tag ")<cr>
" SkyBison prompt to delete buffer
nnoremap <space>d :<c-u>call skybison#run("bd ")<cr>
" SkyBison prompt to edit a file
nnoremap <space>e  :<c-u>call skybison#run("e ")<cr>
" SkyBison prompt to edit a TagFile
nnoremap <space>f :<c-u>call skybison#run("F ", 2)<cr>
" SkyBison prompt to load a session
nnoremap <space>t :<c-u>call skybison#run("SessionLoad ", 2)<cr>
" SkyBison prompt to jump to a line
nnoremap <space>? :<c-u>call skybison#run("Line ", 2)<cr>

" A normal-mode <cr> mapping breaks some special vim windows, so undo the mapping there
autocmd CmdwinEnter * nnoremap <buffer> <cr> <cr>
autocmd FileType qf nnoremap <buffer> <cr> <cr>
autocmd FileType git nnoremap <buffer> <cr> <cr>
