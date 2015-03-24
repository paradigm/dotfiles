" ==============================================================================
" = c/cpp ftplugin                                                             =
" ==============================================================================

" Vim's cpp ftplugin sources this file, it's effectively C and C++.

" This is a list of directories to be searched for #include macros.
"
" usual UNIX include files
setlocal path+=/usr/include/
" kernel headers
execute "setlocal path+=/lib/modules/" . system("printf \"%s\" $(uname -r)") . "/build/include"
" present working directory
setlocal path+=,
" near by directories
setlocal path+=./include/
setlocal path+=../include/

" regex to match function declarations and definitions
"
" Due to newline matching, does not work with built-in 'define' functionality;
" requires specialized versions.
setlocal define=\\v(^\|;)\\s*(\\w+\\_s+)+\\zs\\ze\\w+\\_s*\\(\\_[^)]*\\)(\\_[^;]*\\{\|;)

" Regex to match #include macros.
setlocal include&vim

" Set compiler/linter
if &filetype == "c"
	setlocal makeprg=gcc\ -Wall\ -Wextra\ %
elseif &filetype == "cpp"
	setlocal makeprg=g++\ -Wall\ -Wextra\ %
endif
setlocal errorformat&vim
let b:lintprg = ""
let b:lintcmd = ""

" Set executable to associate with source
let b:runpath = "./a.out"

" Have 'K' open the man page in a preview window
nnoremap <silent> <buffer> K :<c-u>call preview#man(expand("<cword>"))<cr>

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
	" Use clang to lint
	let b:lintcmd = "cd %:p:h | call ClangUpdateQuickFix() | cd -"
	let b:linterrorformat = &l:errorformat
endif

call snippet#map(";main","
\int main(int argc, char *argv[])
\\<cr>{
\\<cr>(void)argc;
\\<cr>(void)argv;
\\<cr>
\\<cr><++>
\\<cr>
\\<cr>\<c-d>return 0;
\\<cr>}")

call snippet#map(";if","
\if (<++>) {
\\<cr><++>
\\<cr>}")

call snippet#map(";for","
\for (<++>) {
\\<cr><++>
\\<cr>}")

call snippet#map(";while","
\while (<++>) {
\\<cr><++>
\\<cr>}")

call snippet#map(";do","
\do {
\\<cr><++>
\\<cr>} while (<++>)")

call snippet#map(";func","
\<++>(<++>)
\\<cr>{
\\<cr><++>
\\<cr>}")

call snippet#map(";printf","
\printf(\"<++>\", <++>);<++>")
