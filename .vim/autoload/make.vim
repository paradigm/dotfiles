" ==============================================================================
" = make                                                                       =
" ==============================================================================
"
" Figure out specifics for what to compile with :make based on filetype and
" context

function! make#run()
	" First, save buffer.  It is unlikely the user will want to compile a
	" non-current version when the compile is requested, and it is likely that
	" the user could forget to save before calling this.
	w
	" Move the directory containing the current buffer.  This is helpful in
	" case multiple buffers are open which have different associated
	" Makefiles.
	cd %:p:h
	" Set the 'makeprg', 'errorformat'.  Three possibilities:
	" 1. If there is a g:Makeprg, probably project-specific make instructions,
	" use that
	" 2. Otherwise, if there is a Makefile in the pwd, use that (i.e. vim
	" default)
	" 3. Otherwise, use a filetype-specific compiler/linter
	if exists("g:Makeprg")
		execute "setlocal makeprg=" . escape(g:Makeprg, " \\")
		if exists("g:errorformat")
			execute "setlocal errorformat=" . escape(g:Errorformat, " \\")
		endif
	elseif filereadable("./Makefile") || filereadable("./makefile")
		setlocal makeprg&vim
		setlocal errorformat&vim
	elseif &ft == "c"
		setlocal makeprg=gcc\ -Wall\ -Wextra\ %
		setlocal errorformat&vim
	elseif &ft == "cpp"
		setlocal makeprg=g++\ -Wall\ -Wextra\ %
		setlocal errorformat&vim
	elseif &ft == "java"
		" assumes eclim
		call eclim#lang#UpdateSrcFile('java',1) " have eclim populate loclist
		let g:EclimJavaValidate = 0             " disable auto-check
		" ensure auto-check disabled
		autocmd! eclim_java
		" ensure pop-up error explanation disabled
		autocmd! eclim_show_error
		call setqflist(getloclist(0))           " transfer loclist into qflist
		call cconerror#run()
		return
	elseif &ft == "tex"
		" Assumes lualatex.  Lots of massaging to do things like make some
		" multi-line errors squashed to one line for errorformat.
		setlocal makeprg=lualatex\ \-file\-line\-error\ \-interaction=nonstopmode\ %\\\|\ awk\ '/^\\(.*.tex$/{sub(/^./,\"\",$0);X=$0}\ /^!/{sub(/^./,\"\",$0);print\ X\":1:\"$0}\ /tex:[0-9]+:\ /{A=$0;MORE=2}\ (MORE==2\ &&\ /^l.[0-9]/){sub(/^l.[0-9]+[\ \\t]+/,\"\",$0);B=$0;MORE=1}\ (MORE==1\ &&\ /^[\ ]+/){sub(/^[\ \\t]+/,\"\",$0);print\ A\":\ \"B\"·\"$0;MORE=0}'
		setlocal errorformat=%f:%l:\ %m
	elseif &ft == "python"
		" Run pep8 and pylint, then massage with awk so they can both be
		" parsed by the same errorformat.
		execute "setlocal makeprg=" . escape(
					\ 'sh -c "pep8 %; pylint -r n -f parseable --include-ids=y % \\| ' .
					\ "awk -F: '{print \\$1" .
					\ '\":\"\$2\":1:\"\$3\$4\$5\$6\$7\$8\$9' .
					\ "}'" .
					\ '"', "\" \\")
		setlocal errorformat=%f:%l:%c:\ %m
	elseif &ft == "dot"
		setlocal makeprg=dot\ -Tpng\ %\ -o\ %:r.png
		setlocal errorformat=%EError:\ %f:%l:%m,%WWarning:\ %f:\ %*[^0-9]%l%m
	else
		" Couldn't figure out what is desired, fall back to Vim's default.
		setlocal makeprg&vim
		setlocal errorformat&vim
	endif
	" make
	silent! make
	" clear bottom line of any output
	redraw!
	" check if there were any errors/results of make and, if so, jump to it
	call cconerror#run()
endfunction


