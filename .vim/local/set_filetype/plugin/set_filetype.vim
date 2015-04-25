" Set filetype
autocmd BufRead,BufNewFile .vimperatorrc  setlocal filetype=vim
autocmd BufRead,BufNewFile .pentadactylrc setlocal filetype=vim
autocmd BufNewFile,BufRead *.x68          setlocal filetype=asm68k
autocmd BufNewFile,BufRead *.md           setlocal filetype=markdown
autocmd BufNewFile,BufRead *.gv           setlocal filetype=dot
autocmd BufRead *                         if getline(1) =~ '\v^#!.*busybox sh$' | setlocal filetype=sh | endif
