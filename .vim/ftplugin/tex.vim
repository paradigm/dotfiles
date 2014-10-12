" ==============================================================================
" = tex ftplugin                                                               =
" ==============================================================================

" Default to LaTeX, not Plain TeX/ConTeXt/etc
let g:tex_flavor='latex'

" LuaTeX embeds Lua code into TeX documents.  The following code tells vim to
" use Lua highlighting in the relevant sections within a TeX document.
if exists("b:current_syntax") && b:current_syntax == "tex"
	unlet b:current_syntax
	syntax include @TEX syntax/tex.vim
	unlet b:current_syntax
	syntax include @LUA syntax/lua.vim
	syntax match texComment '%.*$' containedin=luatex contains=@texCommentGroup
	syntax region luatex matchgroup=Snip start='\\directlua{' end='}' containedin=@TEX contains=@LUA contains=@texComment
	highlight link Snip SpecialComment
	let b:current_syntax="luatex"
endif

" Various mappings
nnoremap <buffer> <space>o :silent execute "!mupdf " . expand("%:r").".pdf &"<cr>
inoremap <buffer> <c-j> <ESC>:call LatexJump()<cr>
inoremap <buffer> ;; <ESC>o\item<space>
inoremap <buffer> ;' <ESC>o\item[]\hfill<cr><TAB><++><ESC>k0f[a
inoremap <buffer> (( \left(\right)<++><ESC>10hi
inoremap <buffer> [[ \left[\right]<++><ESC>10hi
inoremap <buffer> {{ \left\{\right\}<++><ESC>11hi
inoremap <buffer> __ _{}<++><ESC>4hi
inoremap <buffer> ^^ ^{}<++><ESC>4hi
inoremap <buffer> == &=
inoremap <buffer> ;new \documentclass{}<cr>\begin{document}<cr><++><cr>\end{document}<ESC>3kf{a
inoremap <buffer> ;use \usepackage{}<ESC>i
inoremap <buffer> ;f \frac{}{<++>}<++><ESC>10hi
inoremap <buffer> ;td \todo[]{}<esc>i
inoremap <buffer> ;sk \sketch[]{}<esc>i
inoremap <buffer> ;mi \begin{minipage}{.9\columnwidth}<cr>\end{minipage}<ESC>ko
inoremap <buffer> ;al \begin{align*}<cr>\end{align*}<ESC>ko
inoremap <buffer> ;mb \begin{bmatrix}<cr>\end{bmatrix}<ESC>ko
inoremap <buffer> ;mp \begin{pmatrix}<cr>\end{pmatrix}<ESC>ko
inoremap <buffer> ;li \begin{itemize}<cr>\end{itemize}<ESC>ko\item<space>
inoremap <buffer> ;le \begin{enumerate}<cr>\end{enumerate}<ESC>ko\item<space>
inoremap <buffer> ;ld \begin{description}<cr>\end{description}<ESC>ko\item[]\hfill<cr><tab><++><ESC>k0f[a
inoremap <buffer> ;ca \begin{cases}<cr>\end{cases}<ESC>ko
inoremap <buffer> ;tb \begin{tabular}{llllllllll}<cr>\end{tabular}<ESC>ko\toprule<cr>\midrule<cr>\bottomrule<ESC>kko
inoremap <buffer> ;ll \begin{lstlisting}<cr>\end{lstlisting}<ESC>ko
inoremap <buffer> ;df \begin{definition}[]<cr>\end{definition}<ESC>ko<++><esc>k0f[a
inoremap <buffer> ;xp \begin{example}[]<cr>\end{example}<ESC>ko<++><esc>k0f[a
inoremap <buffer> ;sl \begin{solution}<cr>\end{solution}<ESC>ko<++><esc>k0f[a
vnoremap <buffer> ;u <esc>`>a}_{}<++><esc>`<i\underbrace{<esc>`>2f}i
vnoremap <buffer> ;U <esc>`>a}}_{}$<++><esc>`<i$\underbrace{\text{<esc>`>3f}i
vnoremap <buffer> ;o <esc>`>a}^{}<++><esc>`<i\overbrace{<esc>`>2f}i
vnoremap <buffer> ;O <esc>`>a}}^{}$<++><esc>`<i$\overbrace{\text{<esc>`>3f}i
nnoremap <buffer> <space>& :Tab /&<cr>
xnoremap <buffer> <space>& :Tab /&<cr>
nnoremap <buffer> <space>\ :Tab /\\\\<cr>
xnoremap <buffer> <space>\ :Tab /\\\\<cr>

" Create a text object for LaTeX environments
xnoremap iv :<c-u>call LatexEnv(1)<CR>
onoremap iv :normal viv<cr>
xnoremap av :<c-u>call LatexEnv(0)<CR>
onoremap av :normal vav<cr>

" set where to store language-specific tags
let b:paratags_lang_tags = "~/.vim/tags/latextags"
" set where to look for library
call paratags#langadd("/usr/share/textmf-texlive/tex/latex/")
call paratags#langadd("/usr/share/texmf/tex/latex/")
call paratags#langadd("~/texmf/tex/latex/")
call paratags#langadd("~/.texmf/tex/latex/")

" Tabularize Automatically
" Disabled as more troublesome than helpful
"inoremap & &<Esc>:let columnnum=<c-r>=strlen(substitute(getline('.')[0:col('.')],'[^&]','','g'))<cr><cr>:Tabularize /&<cr>:normal 0<cr>:normal <c-r>=columnnum<cr>f&<cr>a

" Jumps to next <++>.  Conceptually based on vim-latexsuite's equivalent.
function! LatexJump()
	if search('<++>') == 0
		normal! l
		startinsert
	else
		execute "normal! v3l\<c-g>"
	endif
endfunction

" Used to create a text object for LaTeX environments.  Searchpair() seems to
" have problems with backslashes, so that part was dropped from the search.
" Moreover, this assumes that \begin, the content, and \end are all on
" different lines.

function! LatexEnv(inner)
	call searchpair("begin\{.*\}",'',"end\{.*\}",'bW')
	if a:inner
		normal j
	endif
	normal V
	call searchpair("begin\{.*\}",'',"end\{.*\}",'W')
	if a:inner
		normal k
	endif
endfunction
