" ==============================================================================
" = paratags                                                                   =
" ==============================================================================

function! paratags#completegroups(A,L,P)
	let regex = glob2regex#conv(a:A)
	let results = []
	for group in ['buffers', 'include', 'git', 'library']
		if group =~ regex
			let results += [group]
		endif
	endfor
	return results
endfunction

function! paratags#setgroup(group)
	let g:paratags_group = a:group
	if g:paratags_group == 'buffers'
		if !exists("g:tagfile_buffers")
			let g:tagfile_buffers=tempname()
		endif
		setlocal tags=
		execute "set tags=" . g:tagfile_buffers
	elseif g:paratags_group == 'include'
		if !exists("b:tagfile_include")
			let b:tagfile_include=tempname()
		endif
		set tags=
		execute "setlocal tags=" . b:tagfile_include
	elseif g:paratags_group == 'git'
		if system('git rev-parse --show-toplevel')[0] != '/'
			echoerr "ParaTags: Not in a git repository"
			return
		endif
		let git_top = system('git rev-parse --show-toplevel')
		if !exists("g:tagfile_git")
			let g:tagfile_git = system('git rev-parse --show-toplevel')[:-2] . '/.git/tags'
		endif
		setlocal tags=
		execute "set tags=" . g:tagfile_git
		if !filereadable(g:tagfile_git)
			echoerr "ParaTags: No git tag file"
			return
		endif
	elseif g:paratags_group == 'library'
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
	endif
endfunction

function! paratags#autorefresh()
	if g:paratags_autorefresh[g:paratags_group]
		call paratags#manualrefresh()
	endif
endfunction

function! paratags#manualrefresh()
	" set buffer-local 'tag'
	call paratags#setgroup(g:paratags_group)
	redraw
	echo "ParaTags refreshing " . g:paratags_group . "..."

	if g:paratags_group == 'buffers'
		if filereadable(g:tagfile_buffers)
			call writefile([], g:tagfile_buffers)
		endif
		for bufnr in range(1,bufnr("$"))
			if buflisted(bufnr)
				let bufname = bufname(bufnr)
				if bufname[0] != "/"
					let bufname = getcwd()."/".bufname
				endif
				call system("ctags -a -f " . g:tagfile_buffers . " --language-force=" . s:GetCtagsFiletype(getbufvar(bufnr, "&filetype")) . " " . bufname)
			endif
		endfor
	elseif g:paratags_group == 'include'
		let files = parainclude#include_files()
		call system("ctags -f " . b:tagfile_include . " --language-force=" . s:GetCtagsFiletype(&filetype) . " " . join(files))
	elseif g:paratags_group == 'git'
		call system("git ctags)
	elseif g:paratags_group == 'library'
		let paths = filter(split(&path, '\\\@<!,'), 'v:val != "" && v:val[0] != "."')
		if len(paths) == 0
			echoerr "ParaTags: no valid entries in 'path'"
			return
		endif
		call system("ctags -R -f ~/.vim/tags/" . &filetype . " " . join(paths))
		redraw
	endif
	redraw
	echo "ParaTags done"
endfunction

" maps vim's filetype to corresponding ctag's filetype
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
