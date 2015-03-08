" ==============================================================================
" = paratags                                                                   =
" ==============================================================================
"
" Code to generate and manage tags

" Store tags in a temporary file
let s:buffertagfile = tempname()
execute "set tags+=" . s:buffertagfile

" Generates tags for open buffers.  This is fast enough to do before every
" call to use a tag.  The effect is the same as having any file altered in the
" given Vim session have its tags updated automatically provided the user does
" not :bd the buffer.
function! paratags#buffers()
	redraw
	echo "paratags#buffers working..."
	if filereadable(s:buffertagfile)
		call delete(s:buffertagfile)
	endif
	for l:buffer_number in range(1,bufnr("$"))
		if buflisted(l:buffer_number)
			let l:buffername = bufname(l:buffer_number)
			if l:buffername[0] != "/"
				let l:buffername = getcwd()."/".l:buffername
			endif
			call system("ctags -a -f ".s:buffertagfile." --language-force=".s:GetCtagsFiletype(getbufvar(l:buffer_number,"&filetype"))." ".l:buffername)
		endif
	endfor
	redraw
	echo "paratags#buffers Done"
endfunction

" Generate tags for a given language's libraries, per 'path'.
function! paratags#path()
	let paths = filter(split(&path, '\\\@<!,'), 'v:val != "" && v:val[0] != "."')
	if len(paths) == 0
		redraw
		echo "paratags#path no valid 'path' items"
		return
	endif
	redraw
	echo "paratags#path populating " . &ft . " from: " . join(paths)
	call system("mkdir -p ~/.vim/tags/")
	call system("ctags -R -f ~/.vim/tags/" . &ft . " " . join(paths))
	redraw
	echo "paratags#path done"
endfunction

" Enables the language library tags
function! paratags#path_enable()
	execute "setlocal tags+=~/.vim/tags/" . &ft
endfunction

" Disables the language library tags
function! paratags#path_disable()
	execute "setlocal tags-=~/.vim/tags/" . &ft
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
