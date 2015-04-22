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
"
" Fails in many cases:
" - False negatives on anything comments or preprocessor part-way through
" - False positives on macros
" - False positives if wrapped in comment or string
" - False negatives on K&R C style, requires ANSI
" - Fails with C++:
"   - False negative on Constructors and Destructors due to lack of return value
"   - False positive on initialization with parens, e.g. `int x(5);`
set define=\\v(^\|}\|;)\\s*(<else>)@!(\\h\\w*(\\s+[*&])?\\_s+)+\\zs\\h\\w*\\ze\\_s*\\(
"             |           ||        ||                        ||             |       \- opening ( for args
"             |           ||        ||                        |\-------------+- func name
"             |           ||        |\------------------------+- return value, qualifiers (e.g. const int)
"             |           |\+-------+- do not consider "else" a return value / qualifier, avoids recognizing "else if (" as function
"             \--------+- possible preceding situation.
"                         Using start-of-line rather than more correct
"                         start-of-buffer to avoid having to parse out
"                         #include's and comments common up top.


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
nnoremap <silent> <buffer> K :<c-u>call preview#man(expand("<cword>"), '')<cr>

" If clang exists, use clang
if exists('g:clang_complete_loaded')
	" jump to declaration
	" note g<c-]> is still available to access tag jump
	nnoremap <buffer> <c-]>        :call support#push_stack()<cr>:call g:ClangGotoDeclaration()<cr>
	" jump to declaration without using tag stack
	nnoremap <buffer> gd           :call g:ClangGotoDeclaration()<cr>
	" pop tag stack
	nnoremap <buffer> <c-t>        :call support#pop_stack()<cr>
	" preview declaration
	nnoremap <buffer> <space>P     :call g:ClangGotoDeclarationPreview()<cr>
	" preview declaration line
	nnoremap <buffer> <space><c-p> :call preview#line("call g:ClangGotoDeclaration()", '!')<cr>
	" Use clang to lint
	let b:lintcmd = "cd %:p:h | call ClangUpdateQuickFix() | cd -"
	let b:linterrorformat = &l:errorformat
endif

call snippet#add(";main","
\int main(int argc, char *argv[])
\\<cr>{
\\<cr>(void)argc;
\\<cr>(void)argv;
\\<cr>
\\<cr><++>
\\<cr>
\\<cr>\<c-d>return 0;
\\<cr>}")

call snippet#add(";if","
\if (<++>) {
\\<cr><++>
\\<cr>}")

call snippet#add(";for","
\for (<++>) {
\\<cr><++>
\\<cr>}")

call snippet#add(";while","
\while (<++>) {
\\<cr><++>
\\<cr>}")

call snippet#add(";do","
\do {
\\<cr><++>
\\<cr>} while (<++>)")

call snippet#add(";func","
\<++>(<++>)
\\<cr>{
\\<cr><++>
\\<cr>}")

call snippet#add(";printf","
\printf(\"<++>\", <++>);<++>")
