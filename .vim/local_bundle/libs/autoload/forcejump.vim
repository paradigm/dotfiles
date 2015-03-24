function! forcejump#run()
	execute "silent! keeppatterns normal! /\\%" . line(".") . "l\\%" . col(".") . "c\<cr>"
endfunction
