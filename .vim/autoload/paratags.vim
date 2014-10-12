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
" given Vim session has its tags updated automatically provided the user does
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

" Generates tags for the libraries in a given language.  Note that some
" languages have huge libraries and this could take a while
function! paratags#langgen()
	echo "paratags#langgen working..."
	if exists("b:paratags_lang_tags") && exists("b:paratags_lang_sources")
		call system("mkdir -p ~/.vim/tags/")
		call system("ctags -R -f " . b:paratags_lang_tags . " " . join(b:paratags_lang_sources))
	endif
	redraw
	echo "paratags#langgen done"
endfunction

" Adds a source for paratags#langen()
function! paratags#langadd(source)
	if !exists("b:paratags_lang_sources")
		let b:paratags_lang_sources = []
	endif
	if index(b:paratags_lang_sources, a:source)
		let b:paratags_lang_sources += [a:source]
	endif
endfunction

" Enables the language library tags
function! paratags#langenable()
	if exists("b:paratags_lang_tags")
		execute "set tags +=" . b:paratags_lang_tags
	endif
endfunction

" Disables the language library tags
function! paratags#langdisable()
	if exists("b:paratags_lang_tags")
		execute "set tags -=" . b:paratags_lang_tags
	endif
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
