" -----------------------------------------------------------------------------
" default to the first group

let s:i = 0

" -----------------------------------------------------------------------------
" general paratags functions

function! paratags#cmdline_completion(A,L,P)
	let regex = support#glob2regex(a:A)
	let results = []
	for group in map(copy(g:paratags_groups), 'v:val["name"]')
		if group =~ regex
			let results += [group]
		endif
	endfor
	return results
endfunction

function! paratags#status()
	redraw
	echo "ParaTags group=" . g:paratags_groups[s:i]['name'] . ' auto=' . g:paratags_groups[s:i]['auto']
endfunction

function! paratags#group(name)
	let found = 0
	for i in range(0, len(g:paratags_groups)-1)
		if g:paratags_groups[i]['name'] == a:name
			let s:i = i
			let found = 1
			break
		endif
	endfor
	if !found
		echohl ErrorMsg
		echo "ParaTags: no such group \"" . a:name . "\""
		echohl Normal
		return
	endif
	call function(g:paratags_groups[s:i]['tagfile_func'])()
	call paratags#status()
endfunction

function! paratags#auto()
	if g:paratags_groups[s:i]['auto']
		call paratags#refresh()
	endif
endfunction

function! paratags#refresh()
	redraw
	echo 'ParaTags refreshing ' . g:paratags_groups[s:i]['name'] . '... '
	call function(g:paratags_groups[s:i]['refresh_func'])()
	echon "done"
endfunction

function! paratags#toggleauto()
	let g:paratags_groups[s:i]['auto'] = ! g:paratags_groups[s:i]['auto']
	call paratags#status()
endfunction

" -----------------------------------------------------------------------------
" buffers

function! paratags#buffers_tagfile()
	if !exists("s:buffers_tagfile")
		let s:buffers_tagfile = tempname()
	endif
	setlocal tags=
	execute 'set tags=' . s:buffers_tagfile
endfunction

function! paratags#buffers_refresh()
	call paratags#buffers_tagfile()
	if filereadable(s:buffers_tagfile)
		call writefile([], s:buffers_tagfile)
	endif
	for bufnr in range(1,bufnr("$"))
		if buflisted(bufnr)
			let bufname = bufname(bufnr)
			if bufname[0] != "/"
				let bufname = getcwd()."/".bufname
			endif
			call system("ctags --tag-relative=yes -a -f " . s:buffers_tagfile . " --language-force=" . s:GetCtagsFiletype(getbufvar(bufnr, "&filetype")) . " " . bufname)
		endif
	endfor
endfunction

" -----------------------------------------------------------------------------
" include

function! paratags#include_tagfile()
	if !exists("b:include_tagfile")
		let b:include_tagfile = tempname()
	endif
	set tags=
	execute 'setlocal tags=' . b:include_tagfile
endfunction

function! paratags#include_refresh()
	call paratags#include_tagfile()
	let files = parainclude#include_files()
	call system("ctags --tag-relative=yes -f " . b:include_tagfile . " --language-force=" . s:GetCtagsFiletype(&filetype) . " " . join(files))
endfunction

" -----------------------------------------------------------------------------
" git

function! paratags#git_tagfile()
	let git_top = system('git rev-parse --show-toplevel')[:-2]
	if git_top[0] != '/'
		echoerr "ParaTags: Not in a git repository"
		return
	endif
	if !exists("s:git_tagfile")
		let g:git_tagfile = git_top . '/.git/tags'
	endif
	setlocal tags=
	execute "set tags=" . g:git_tagfile
endfunction

function! paratags#git_refresh()
	call paratags#git_tagfile()
	let git_top = system('git rev-parse --show-toplevel')[:-2]
	let git_hook =  git_top . '/.git/hooks/ctags'
	if executable(git_hook)
		call system(git_hook)
	else
		echoerr "Could not find ctag hook at \"" . git_hook . "\""
	endif
endfunction

" -----------------------------------------------------------------------------
" library

function! paratags#library_tagfile()
	if &filetype == ''
		echoerr "ParaTags: No filetype set"
		return
	endif
	if !isdirectory("~/.vim/tags/")
		call system("mkdir -p ~/.vim/tags/")
	endif
	if !exists("b:tagfile_library")
		let b:tagfile_library="~/.vim/tags/" . &filetype
	endif
	set tags=
	execute "setlocal tags=" . b:tagfile_library
endfunction

function! paratags#library_refresh()
	let paths = filter(split(&path, '\\\@<!,'), 'v:val != "" && v:val[0] != "."')
	if len(paths) == 0
		echoerr "ParaTags: no valid entries in 'path'"
		return
	endif
	call system("ctags -R -f ~/.vim/tags/" . &filetype . " " . join(paths))
	redraw
endfunction

" -----------------------------------------------------------------------------
" favorites

function! paratags#favorites_tagfile()
	if !exists("s:favorites_tagfile")
		let s:favorites_tagfile = $HOME . '/.vim/favorites'
	endif
	setlocal tags=
	execute 'set tags=' . s:favorites_tagfile
endfunction

function! paratags#favorites_refresh()
	" maintained manually, no way to 'refresh'
endfunction

function! paratags#favorites_add(...)
	if a:0 == 0
		let name = input("Favorite Name: ")
	else
		let name = a:1
	endif

	let file = $HOME . '/.vim/favorites'
	if filereadable(file)
		let contents = readfile(file)
	else
		let contents = []
	endif

	if index(map(contents, 'split(v:val,"\t")[0]'), name) != -1
		echoerr "Name already used"
		return
	endif
	
	if filereadable(file)
		let contents = readfile(file)
	else
		let contents = []
	endif

	let contents += [
				\ name . "\t" .
				\ expand("%:p") . "\t" .
				\ 'normal! ' . line(".") . 'G' . virtcol('.') . '|'
				\ ]
	call writefile(contents, file)
endfunction

" -----------------------------------------------------------------------------
" map vim's filetype to corresponding ctag's filetype

function! s:GetCtagsFiletype(vimfiletype)
	if a:vimfiletype == "asm"
		return("asm")
	elseif a:vimfiletype == "asm68k"
		return("asm68k")
	elseif a:vimfiletype == "aspperl"
		return("asp")
	elseif a:vimfiletype == "aspvbs"
		return("asp")
	elseif a:vimfiletype == "awk"
		return("awk")
	elseif a:vimfiletype == "beta"
		return("beta")
	elseif a:vimfiletype == "c"
		return("c")
	elseif a:vimfiletype == "cpp"
		return("c++")
	elseif a:vimfiletype == "cs"
		return("c#")
	elseif a:vimfiletype == "cobol"
		return("cobol")
	elseif a:vimfiletype == "eiffel"
		return("eiffel")
	elseif a:vimfiletype == "erlang"
		return("erlang")
	elseif a:vimfiletype == "expect"
		return("tcl")
	elseif a:vimfiletype == "fortran"
		return("fortran")
	elseif a:vimfiletype == "html"
		return("html")
	elseif a:vimfiletype == "java"
		return("java")
	elseif a:vimfiletype == "javascript"
		return("javascript")
	elseif a:vimfiletype == "tex" && g:tex_flavor == "tex"
		return("tex")
		" LaTeX is not supported by default, add to ~/.ctags
	elseif a:vimfiletype == "tex" && g:tex_flavor == "latex"
		return("latex")
	elseif a:vimfiletype == "lisp"
		return("lisp")
	elseif a:vimfiletype == "lua"
		return("lua")
	elseif a:vimfiletype == "make"
		return("make")
		" markdown is not supported by default, add to ~/.ctags
	elseif a:vimfiletype == "markdown"
		return("markdown")
	elseif a:vimfiletype == "pascal"
		return("pascal")
	elseif a:vimfiletype == "perl"
		return("perl")
	elseif a:vimfiletype == "php"
		return("php")
	elseif a:vimfiletype == "python"
		return("python")
	elseif a:vimfiletype == "rexx"
		return("rexx")
	elseif a:vimfiletype == "ruby"
		return("ruby")
	elseif a:vimfiletype == "scheme"
		return("scheme")
	elseif a:vimfiletype == "sh"
		return("sh")
	elseif a:vimfiletype == "csh"
		return("sh")
	elseif a:vimfiletype == "zsh"
		return("sh")
	elseif a:vimfiletype == "slang"
		return("slang")
	elseif a:vimfiletype == "sml"
		return("sml")
	elseif a:vimfiletype == "sql"
		return("sql")
	elseif a:vimfiletype == "tcl"
		return("tcl")
	elseif a:vimfiletype == "vera"
		return("vera")
	elseif a:vimfiletype == "verilog"
		return("verilog")
	elseif a:vimfiletype == "vhdl"
		return("vhdl")
	elseif a:vimfiletype == "vim"
		return("vim")
	elseif a:vimfiletype == "yacc"
		return("yacc")
	else
		return("")
	endif
endfunction
