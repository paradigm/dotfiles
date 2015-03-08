" Set filetype
autocmd BufRead,BufNewFile .vimperatorrc  setfiletype vim
autocmd BufRead,BufNewFile .pentadactylrc setfiletype vim
autocmd BufNewFile,BufRead *.x68          setfiletype asm68k
autocmd BufNewFile,BufRead *.md           setfiletype markdown
autocmd BufNewFile,BufRead *.gv           setfiletype dot
