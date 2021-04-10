" ==============================================================================
" = python ftplugin                                                            =
" ==============================================================================

" PEP8-friendly tab settings
setlocal expandtab
setlocal tabstop=4
setlocal shiftwidth=4
setlocal softtabstop=4

setlocal define=\\v^\\s*def\ \\zs\\ze

call glob("/usr/lib/py*", 0, 1)
call glob("/usr/local/lib/py*", 0, 1)
execute "setlocal path+=" . join(glob("/usr/lib/py*", 0, 1) + glob("/usr/local/lib/py*", 0, 1), ",")

let b:runpath = expand("%:p")

" python syntax-based folding yanked from
" http://vim.wikia.com/wiki/Syntax_folding_of_Python_files
setlocal foldtext=substitute(getline(v:foldstart),'\\t','\ \ \ \ ','g')

let b:lintprg = 'sh -c "pep8 %; pylint -r n -f parseable --include-ids=y % \\| ' .
			\ "awk -F: '{print \\$1" .
			\ '\":\"\$2\":1:\"\$3\$4\$5\$6\$7\$8\$9' .
			\ "}'" .
			\ '"'
let b:linterrorformat='%f:%l:%c:\ %m'

if executable('pyls')
	autocmd User lsp_setup call lsp#register_server({
				\   'name': 'Python Language Server',
				\   'cmd': {server_info->['pyls']},
				\   'whitelist': ['python'],
				\ })
endif
