" populate signs column after quickfix is populated
autocmd QuickFixCmdPost * call quickfixsigns#run()
