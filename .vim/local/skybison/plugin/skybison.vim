" Enable fuzzing in skybison
"let g:skybison_fuzz = 2

" Switch from normal cmdline to SkyBison
cnoremap <c-l>     <c-\>eskybison#cmdline_switch()<cr><cr>
autocmd CmdwinEnter * let b:cmdline_window_running = 1

" Settings for skybison window
autocmd User skybison_setup inoremap <buffer> <silent> <c-c> <esc>:call skybison#quit()<cr>
autocmd User skybison_setup nnoremap <buffer> <silent> <c-c> :call skybison#quit()<cr>
autocmd User skybison_setup nnoremap <buffer> <silent> <esc> :call skybison#quit()<cr>

" General SkyBison prompt
nnoremap <space>; :<c-u>call skybison#run()<cr>
" SkyBison prompt for buffers
nnoremap <cr>     :<c-u>call skybison#run("b ", 2)<cr>
" (re)generate local tags then have SkyBison prompt for tags
nnoremap <bs>      :<c-u>PTAuto<cr>2:<c-u>call skybison#run("tag ")<cr>
nnoremap <c-\>     :call skybison#run("Djump ")<cr>
" SkyBison prompt to delete buffer
nnoremap <space>d :<c-u>call skybison#run("bd ")<cr>
" SkyBison prompt to edit a file
nnoremap <space>e  :<c-u>call skybison#run("E ")<cr>
" SkyBison prompt to load a session
nnoremap <space>t :<c-u>call skybison#run("SessionLoad ", 2)<cr>
" SkyBison prompt to jump to a line
nnoremap <space>? :<c-u>call skybison#run("Line ", 2)<cr>
" SkyBison prompt from favorites tags
nnoremap <space>f :<c-u>call SkyBisonParaTagsFavorites()<cr>
function! SkyBisonParaTagsFavorites()
	augroup SkyBisonParaTagsFavorites
	autocmd User skybison_end PTPrevious | autocmd! SkyBisonParaTagsFavorites
	augroup END
	PTGroup favorites
	call skybison#run('tag ', 2)
endfunction

" A normal-mode <cr> mapping breaks some special vim windows, so undo the mapping there
autocmd CmdwinEnter * nnoremap <buffer> <cr> <cr>
autocmd FileType qf nnoremap <buffer> <cr> <cr>
autocmd FileType git nnoremap <buffer> <cr> <cr>
