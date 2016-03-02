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

" If jedi exists, use jedi
"
" jedi doesn't seem to use a g:load... variable, but it does define :Pyimport
" in plugin so we can check for that.
if exists(":Pyimport")
	" jump to definition
	nnoremap <buffer> <c-]> :call support#push_stack()<cr>:call jedi#goto_definitions()<cr>
	" jump to assignment
	nnoremap <buffer> gd :call jedi#goto_assignments()<cr>
	" pop tag stack
	nnoremap <buffer> <c-t> :call support#pop_stack()<cr>
	" preview declaration
	nnoremap <buffer> <space>P :normal mP<cr>:pedit!<cr>:wincmd w<cr>:normal `P\d<cr>:wincmd w<cr>
	" preview declaration line
	nnoremap <buffer> <space><c-p> :call preview#jump("normal \\d", 1)<cr>
endif
