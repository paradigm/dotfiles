" ==============================================================================
" = cpp ftplugin                                                               =
" ==============================================================================
"
" Open man page for word under cursor in preview window.  Can prefix a count
" to do which mount number, e.g.: 2K will open "man 2 <cword>"
nnoremap <buffer> K :<c-u>call preview#shell("man " . (v:count > 0 ? v:count : "") . " " . expand("<cword>"))<cr>

" If clang exists, use clang
if exists('g:clang_complete_loaded')
	" jump to declaration
	nnoremap <buffer> <c-]>        :FTStackPush<cr>:call g:ClangGotoDeclaration()<cr>
	" jump to declaration without using tag stack
	nnoremap <buffer> gd           :call g:ClangGotoDeclaration()<cr>
	" pop tag stack
	nnoremap <buffer> <c-t>        :FTStackPop<cr>
	" preview declaration
	nnoremap <buffer> <space>P     :call g:ClangGotoDeclarationPreview()<cr>
	" preview declaration line
	nnoremap <buffer> <space><c-p> :call preview#line("call g:ClangGotoDeclaration()")<cr>
else
	" language-specific plugin, fall back to ctags
	" set where to store language-specific tags
	let b:paratags_lang_tags = "~/.vim/tags/cpptags"
	" set where to look for library
	call ParaTagsLangAdd("/usr/include/c++/")
endif
