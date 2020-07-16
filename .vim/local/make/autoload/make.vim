" ==============================================================================
" = make                                                                       =
" ==============================================================================

function! make#make()
	" Save buffer.  It is unlikely the user will want to compile a
	" non-current version when the compile is requested, and it is likely that
	" the user could forget to save before calling this.
	w

	" Back up settings
	let l:makeprg = &l:makeprg
	let l:errorformat = &l:errorformat

	" Determine proper make to use in the given context.
	"
	" Global variable takes highest precedence.
	if get(g:, "Makeprg", "") != ""
		let &l:makeprg = g:Makeprg
	elseif filereadable("./Makefile") || filereadable("./makefile")
		" If there is a makefile, use it.
		setlocal makeprg&vim
	else
		" makeprg should be set from filetype
	endif

	" Global variable takes highest precedence.
	if get(g:, "Errorformat", "") != ""
		let &l:errorformat = g:Errorformat
	else
		" errorformat should be set from filetype
	endif

	" make
	silent! lmake
	" clear bottom line of any output
	redraw!
	" if there are any results, jump to the first one
	call support#ll()

	" restore possibly changed setting
	let &l:makeprg = l:makeprg
	let &l:errorformat = l:errorformat
endfunction

function! make#lint()
	" Save buffer.  It is unlikely the user will want to compile a
	" non-current version when the compile is requested, and it is likely that
	" the user could forget to save before calling this.
	w

	" Back up settings
	let l:makeprg = &l:makeprg
	let l:errorformat = &l:errorformat

	" Determine proper make to use in the given context.
	let l:lintcmd = ""
	if get(b:, "lintprg", "") != ""
		let &l:makeprg = b:lintprg
		let l:lintcmd = "lmake"
	elseif get(b:, "lintcmd", "") != ""
		let l:lintcmd = b:lintcmd
	endif
	if get(b:, "linterrorformat", "") != ""
		let &l:errorformat = b:linterrorformat
	endif

	if l:lintcmd != ""
		silent execute l:lintcmd
		" clear bottom line of any output
		redraw!
		" if there are any results, jump to the first one
		call support#cc()
	else
		redraw
		echohl ErrorMsg
		echo "make#lint(): no linter set"
		echohl Normal
	endif

	" restore possibly changed setting
	let &l:makeprg = l:makeprg
	let &l:errorformat = l:errorformat
endfunction
