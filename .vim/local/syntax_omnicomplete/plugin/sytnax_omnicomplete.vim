" If a filetype doesn't have it's own omnicompletion, but it does have syntax
" highlighting, use that for omnicompletion
autocmd Filetype *
			\  if &omnifunc == ""
			\|   setlocal omnifunc=syntaxcomplete#Complete
			\| endif
