" ==============================================================================
" = paradigm's_.vimrc                                                          =
" ==============================================================================
"
" Disclaimer: Note that I have unusual tastes.  Blindly copying lines from this
" or any of my configuration files will not necessarily result in what you will
" consider a sane system.  Please do your due diligence in ensuring you fully
" understand what will happen if you attempt to utilize content from this file,
" either in part or in full.

" ==============================================================================
" = general_settings                                                           =
" ==============================================================================
"
" These are general settings that don't fit well into any of the categories
" used below.  Order may matter for some of these.

" Disable vi compatibility restrictions.  Yes, this is unnecessary.
set nocompatible
" When creating a new line, set indentation same as previous line.
set autoindent
" Allow i_backspace over indent, eol and start-of-insert
set backspace=2
" Automatically determine folds based on syntax
set foldmethod=syntax
" Do not fold anything by default.
set foldlevelstart=999
" Allow modified/unsaved buffers in the background.
set hidden
" Highlight search results.
set hlsearch
" When sourcing this file, do not immediately turn on highlighting.
nohlsearch
" Searches are case-insensitive, except...
set ignorecase
" ...searches are not case-insensitive if an uppercase character appears
" within them.  So just all-lowercase searches are case-insensitive.
set smartcase
" Print line numbers on the left.
set number
" if this vim has 'relativenumber', print line number relative to cursor
if exists('&relativenumber')
	set relativenumber
endif
" Always show cursor position in statusline.
set ruler
" Default color scheme should assume dark background.
set background=dark
" Tabs are four characters wide.  Note that this is primarily useful for those
" who prefer tabs for indentation rather than spaces which act like tabs.  If
" you prefer indenting with spaces, look into 'softtabstop'.
set tabstop=4
" (Auto)indents are four characters wide.
set shiftwidth=4
" If run in a terminal, set the terminal title.
set title
" Enable wordwrap.
set textwidth=0 wrap linebreak
" Enable unicode characters.  This is needed for the 'listchars' below.
set encoding=utf-8
" Use spellcheck
set spell
" Disable capitalization check in spellcheck.
set spellcapcheck=""
" Enable syntax highlighting.
syntax on
" Do not show introduction message when starting Vim.
set shortmess+=I
" Display special characters for certain whitespace situations.
set list
set listchars=tab:>·,trail:·,extends:…,precedes:…,nbsp:&
" Enable menu for command-line completion.
set wildmenu
" When using wildmenu, first press of tab completes the common part of the
" string.  The rest of the tabs begin cycling through options.
set wildmode=longest:full,full
" Timeout for keycodes (such as arrow keys and function keys) is only 10ms.
" Timeout for Vim keymaps is half a second.
"set timeout ttimeoutlen=10 timeoutlen=500
" set what is saved by a :mksession
set sessionoptions=blank,buffers,curdir,folds,help,options,tabpages,winsize,globals,localoptions,tabpages
" Add ~/.vim to the runtimepath in Windows so I can use the same ~/.vim across
" OSs
if has('win32') || has('win64')
	set runtimepath+=~/.vim
endif
" Clear default tags.  Other code later will set tags accordingly.
set tags=""
" Where to store temporary files
let g:tmpdir = "/dev/shm/"
" Where to store the thesaurus.
let g:thesaurusfile = $HOME . '/.vim/thesaurus'
execute "set thesaurus+=" . g:thesaurusfile
" Where to store the dictionary.
let g:dictionaryfile = $HOME . '/.vim/dictionary'
" vim's 'dictionary' doesn't support paradigm's dictionary format, so don't
" set 'dictionary' here.
" leaving this blank means i_ctrl-x_ctrl-k falls back to spellcheck dictionary
"execute "set dictionary+=" . g:dictionaryfile

" Disabled general settings which may be worthwhile to retain in case they are
" desired at a later time.
"
" Automatically save/load settings for buffer when entering/leaving them.
" This was disabled as it proved more troublesome than helpful.  Instead,
" session management code below handles this when desired.
"au BufWinLeave * silent! mkview!  " automatically save view on exit
"au BufWinEnter * silent! loadview " automatically load view on load

" ==============================================================================
" = mappings                                                                   =
" ==============================================================================

" ------------------------------------------------------------------------------
" - general_(mappings)                                                         -
" ------------------------------------------------------------------------------

" Disable <f1>'s default help functionality.  Usually when I hit this key I
" missed an attempt at the <esc> key.
noremap <f1> <esc>
lnoremap <f1> <esc>
" Clear search highlighting, sign column, messages at bottom, and redraw
nnoremap <silent> <c-l> :nohlsearch<cr>:sign unplace *<cr><c-l>
" Faster mapping for saving
nnoremap <space>w :w<cr>
" Faster mapping for closing window / quitting
nnoremap <space>q :q<cr>
" Re-source the .vimrc
nnoremap <space>s :so $MYVIMRC<cr>
" Run wrapper for :make
nnoremap <space>m :Make<cr>
" Run whatever is being worked on
nnoremap <space>r :call Run("sh")<cr>
nnoremap <space>R :call Run("preview")<cr>
nnoremap <space><c-r> :call Run("xterm")<cr>
" Faster mapping for spelling correction
nnoremap <space>z 1z=
" Provide more comfortable alternative to default window resizing mappings.
nnoremap <c-w><c-h> :vertical resize -10<cr>
nnoremap <c-w><c-l> :vertical resize +10<cr>
nnoremap <c-w><c-j> :resize +10<cr>
nnoremap <c-w><c-k> :resize -10<cr>
" Move by 'display lines' rather than 'logical lines' if no v:count was
" provided.  When a v:count is provided, move by logical lines.
nnoremap <expr> j v:count > 0 ? 'j' : 'gj'
xnoremap <expr> j v:count > 0 ? 'j' : 'gj'
nnoremap <expr> k v:count > 0 ? 'k' : 'gk'
xnoremap <expr> k v:count > 0 ? 'k' : 'gk'
" Ensure 'logical line' movement remains accessible.
nnoremap <silent> gj j
xnoremap <silent> gj j
nnoremap <silent> gk k
xnoremap <silent> gk k
" filter selected area through calculator
xnoremap <space>c :!bc -l<cr>
xnoremap <space>C :!sage -q 2>/dev/null \| head -n1 \| cut -c15-<cr>
xnoremap <space>L <esc>`<ilatex(<esc>`>a)<esc>gv:!sage -q 2>/dev/null \| head -n1 \| cut -c15-<cr>
" copy to system clipboard
vnoremap <space>y "+ygv"*y
" Toggle 'paste'
" This particular mapping is nice because I can paste with
" <insert><s-insert><-sinrt>
set pastetoggle=<insert>

" ------------------------------------------------------------------------------
" - next_previous_(mappings)                                                   -
" ------------------------------------------------------------------------------
" Find next/previous search item which is not visible in the window.
" Note that 'scrolloff' probably breaks this.
nnoremap <space>n L$nzt
nnoremap <space>N H$Nzb
" next/previous/first/last change
"nnoremap ]c ]c " this is already default
"nnoremap [c [c " this is already default
nnoremap [C :call WhilePosChange("[c",1,1,1,1)<cr>
nnoremap ]C :call WhilePosChange("]c",1,1,1,1)<cr>
" next/previous/first/last buffer
nnoremap ]b :bnext<cr>
nnoremap [b :bprevious<cr>
nnoremap [B :bfirst<cr>
nnoremap ]B :blast<cr>
" next/previous/first/last tag
nnoremap ]t :tnext<cr>
nnoremap [t :tprevious<cr>
nnoremap [T :tfirst<cr>
nnoremap ]T :tlast<cr>
" next/previous/first/last quickfix item
nnoremap ]q :cnext<cr>
nnoremap [q :cprevious<cr>
nnoremap [Q :cfirst<cr>
nnoremap ]Q :clast<cr>
nnoremap [<c-q> :call WhilePosSame("[q",1,0,0,0)<cr>
nnoremap ]<c-q> :call WhilePosSame("]q",1,0,0,0)<cr>
" next/previous/first/last location list item
nnoremap ]l :lnext<cr>
nnoremap [l :lprevious<cr>
nnoremap [L :lfirst<cr>
nnoremap ]L :llast<cr>
" next/previous/first/last argument list item
nnoremap ]a :next<cr>
nnoremap [a :previous<cr>
nnoremap [A :first<cr>
nnoremap ]A :last<cr>

" ------------------------------------------------------------------------------
" - cmdline-window_(mappings)                                                  -
" ------------------------------------------------------------------------------

" Swap default ':', '/' and '?' with cmdline-window equivalent.
nnoremap : q:i
xnoremap : q:i
nnoremap / q/i
xnoremap / q/i
nnoremap ? q?i
xnoremap ? q?i
nnoremap q: :
xnoremap q: :
nnoremap q/ /
xnoremap q/ /
nnoremap q? ?
xnoremap q? ?
" Have <esc> leave cmdline-window
autocmd CmdwinEnter * nnoremap <buffer> <esc> :q\|echo ""<cr>

" ------------------------------------------------------------------------------
" - diff_(mappings)                                                            -
" ------------------------------------------------------------------------------

nnoremap <c-p>t :diffthis<cr>
nnoremap <c-p>u :diffupdate<cr><c-l>
nnoremap <c-p>x :diffoff<cr>:sign unplace *<cr>
nnoremap <c-p>y do<cr>
nnoremap <c-p>p dp<cr>

" ------------------------------------------------------------------------------
" - visual-mode_searching_(mappings)                                           -
" ------------------------------------------------------------------------------
"
" Many of these were either shamelessly stolen from or inspired by
" SearchParty.  See: https://github.com/dahu/SearchParty.  Thanks, bairui.

" Having v_* and v_# search for visually selected area.
xnoremap * "*y<Esc>/<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr><cr>
xnoremap # "*y<Esc>?<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr><cr>
" Prepare search based on visually-selected area.  Useful for searching for
" something slightly different from something by the cursor.  For example, if
" on "xnoremap" and looking for "nnoremap"
xnoremap / "*y<Esc>q/i<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr><esc>0
" Prepare substitution based on visually-selected area.
xnoremap ? "*y<Esc>q:i%s/<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr>/

" ------------------------------------------------------------------------------
" - insert-mode_completion_(mappings)                                          -
" ------------------------------------------------------------------------------

" Allow ctrl-f/ctrl-b to page through pop-up menu.
inoremap <expr> <c-f> pumvisible() ? "\<pagedown>" : "\<c-o>:call ParaTagsBuffers()\<cr>\<c-o>1\<c-w>}"
" if done without pum, try to open tag
inoremap <expr> <c-b> pumvisible() ? "\<pageup>" : "\<c-o>:pclose\<cr>"
" Have i_ctrl-<space> act like i_ctrl-x_ctrl-o. Note that ctrl-@ is triggered by
" ctrl-<space> in many terminals.
inoremap <c-@> <c-x><c-o>
" Have i_ctrl-l act like i_ctrl-x_ctrl-l.
inoremap <c-l> <c-x><c-l>

" ------------------------------------------------------------------------------
" - preview_window_(mappings)                                                  -
" ------------------------------------------------------------------------------

" close the preview window
nnoremap <space>p :pclose\|cclose\|lclose<cr>

" ------------------------------------------------------------------------------
" - plugins_(mappings)                                                         -
" ------------------------------------------------------------------------------

" ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
" ~ SkyBison_(mappings)                                                        ~
" ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
" SkyBison prompt for buffers
nnoremap <cr>     2:<c-u>call SkyBison("b ")<cr>
" the above map breaks some special vim windows, so undo the mapping there
autocmd CmdwinEnter * nnoremap <buffer> <cr> <cr>
autocmd FileType qf nnoremap <buffer> <cr> <cr>
" (re)generate local tags then have SkyBison prompt for tags
nnoremap <bs>      :<c-u>call ParaTagsBuffers()<cr>2:<c-u>call SkyBison("tag ")<cr>
" SkyBison prompt to edit a file
nnoremap <space>e  :<c-u>call SkyBison("e ")<cr>
" SkyBison prompt to edit a MarkFile
nnoremap <space>f 2:<c-u>call SkyBison("F ")<cr>
" SkyBison prompt to load a session
nnoremap <space>t 2:<c-u>call SkyBison("SessionLoad ")<cr>
" General SkyBison prompt
nnoremap <space>;  :<c-u>call SkyBison("")<cr>
" Switch from normal cmdline to SkyBison
cnoremap <c-l>     <c-r>=SkyBison("")<cr><cr>

" ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
" ~ LanguageTool_(mappings)                                                    ~
" ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
nnoremap <space>lt :LanguageToolCheck<cr>
nnoremap <space>lc :LanguageToolClear<cr>

" ------------------------------------------------------------------------------
" - custom_text_objects_(mappings)                                             -
" ------------------------------------------------------------------------------

"" Create new text objects for pairs of identical characters
"for char in ['$',',','.','/','-','=']
"	exec 'xnoremap i' . char . ' :<C-U>silent!normal!T' . char . 'vt' . char . '<CR>'
"	exec 'onoremap i' . char . ' :normal vi' . char . '<CR>'
"	exec 'xnoremap a' . char . ' :<C-U>silent!normal!F' . char . 'vf' . char . '<CR>'
"	exec 'onoremap a' . char . ' :normal va' . char . '<CR>'
"endfor
" Create a text object for folding regions
xnoremap if :<c-u>silent!normal![zjV]zk<CR>
onoremap if :normal Vif<cr>
xnoremap af :<c-u>silent!normal![zV]z<CR>
onoremap af :normal Vaf<cr>
" Create a text object for LaTeX environments
xnoremap iv :<c-u>call LatexEnv(1)<CR>
onoremap iv :normal viv<cr>
xnoremap av :<c-u>call LatexEnv(0)<CR>
onoremap av :normal vav<cr>
" Create a text object for the entire buffer
xnoremap i<cr> :<c-u>silent!normal!ggVG<cr>
onoremap i<cr> :normal Vi<c-v><cr><cr>
xnoremap a<cr> :<c-u>silent!normal!ggVG<cr>
onoremap a<cr> :normal Vi<c-v><cr><cr>
" Create a text object for recently changed text
xnoremap ic :<c-u>silent!normal!`[V`]v<CR>
onoremap ic :normal vic<cr>
xnoremap ac :<c-u>silent!normal!`[V`]<CR>
onoremap ac :normal vac<cr>
"" Create text object based on indentation level
" Replaced with http://www.vim.org/scripts/script.php?script_id=3037

" ==============================================================================
" = commands                                                                   =
" ==============================================================================

" open :help for argument in same window
command! -nargs=1 -complete=help H :help <args> |
			\ let helpfile = expand("%") |
			\ close |
			\ execute "view ".helpfile

" cd to directory containing current buffer
command! CD :cd %:p:h


" ==============================================================================
" = theme                                                                      =
" ==============================================================================

" Command to see the element name for character under cursor.  Very helpful
" run to see element name under color
command! SyntaxGroup echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')

if &t_Co == 256 && filereadable($HOME . "/.themes/current/terminal/256-theme")
	colorscheme currentterm
endif

" ==============================================================================
" = filetype-specific_settings                                                 =
" ==============================================================================

" ------------------------------------------------------------------------------
" - misc_(filetype-specific)                                                   -
" ------------------------------------------------------------------------------

autocmd BufRead,BufNewFile .vimperatorrc setfiletype vim
autocmd BufRead,BufNewFile .pentadactylrc setfiletype vim

" ------------------------------------------------------------------------------
" - vim_(filetype-specific)                                                   -
" ------------------------------------------------------------------------------

" enable vim folding based on syntax
let g:vimsyn_folding = "afmpPrt"

" - Vim has its own omnicompletion mapping by default, separate from the
"   normal one.  Set the normal omnicompletion mapping to cover the special
"   VimL completion, as well as the custom ctrl-space.
" - get :help for word under cursor
" - Language-specific tag settings.
autocmd Filetype vim
			\  inoremap <buffer> <c-x><c-o> <c-x><c-v>
			\| inoremap <buffer> <c-@> <c-x><c-v>
			\| nnoremap <buffer> K :execute ":help \| execute \"pedit! \" . expand(\"%\") \| q"<cr>
			\| let b:paratags_lang_tags = "~/.vim/tags/vimtags"
			\| call ParaTagsLangAdd("~/.vimrc")
			\| call ParaTagsLangAdd("~/.vim/bundle")

" ------------------------------------------------------------------------------
" - mail_(filetype-specific)                                                   -
" ------------------------------------------------------------------------------

" Use spellcheck by default when composing an email.
autocmd Filetype mail setlocal spell

" ------------------------------------------------------------------------------
" - python_(filetype-specific)                                                 -
" ------------------------------------------------------------------------------

" - PEP8-friendly tab settings
" - python syntax-based folding yanked from
"   http://vim.wikia.com/wiki/Syntax_folding_of_Python_files
" - assumes jedi
" - Language-specific tag settings.
autocmd Filetype python
			\  setlocal expandtab
			\| setlocal tabstop=4
			\| setlocal shiftwidth=4
			\| setlocal softtabstop=4
			\| setlocal tags+=,~/.vim/tags/pythontags
			\| setlocal foldtext=substitute(getline(v:foldstart),'\\t','\ \ \ \ ','g')
			\| nnoremap <buffer> <c-]> :FTStackPush<cr>:call jedi#goto_definitions()<cr>
			\| nnoremap <buffer> <c-t> :FTStackPop<cr>
			\| nnoremap <buffer> gd :call jedi#goto_assignments()<cr>
			\| nnoremap <buffer> <space>P :normal mP<cr>:pedit!<cr>:wincmd w<cr>:normal `P\d<cr>:wincmd w<cr>
			\| nnoremap <buffer> <space><c-p> :call PreviewLine("normal \\d")<cr>
			\| let b:paratags_lang_tags = "~/.vim/tags/pythontags"
			\| call ParaTagsLangAdd("/usr/lib/py* /usr/local/lib/py*")

" ------------------------------------------------------------------------------
" - assembly_(filetype-specific)                                               -
" ------------------------------------------------------------------------------

autocmd BufNewFile,BufRead *.x68 set ft=asm68k
" Set tabstop to 8 for assembly.
autocmd Filetype asm setlocal tabstop=8

" ------------------------------------------------------------------------------
" - c_(filetype-specific)                                                      -
" ------------------------------------------------------------------------------

" - open manpage in preview window
" - use clang_complete to open definition in preview window
" - Language-specific tag settings.
autocmd Filetype c
			\  nnoremap <buffer> K :call PreviewShell("man " . expand("<cword>"))<cr>
			\| nnoremap <buffer> <c-]> :FTStackPush<cr>:call g:ClangGotoDeclaration()<cr>
			\| nnoremap <buffer> <c-t> :FTStackPop<cr>
			\| nnoremap <buffer> <space>P :call g:ClangGotoDeclarationPreview()<cr>
			\| nnoremap <buffer> <space><c-p> :call PreviewLine("call g:ClangGotoDeclaration()")<cr>
			\| let b:paratags_lang_tags = "~/.vim/tags/ctags"
			\| call ParaTagsLangAdd("/usr/include/")

" ------------------------------------------------------------------------------
" - c++_(filetype-specific)                                                    -
" ------------------------------------------------------------------------------

" - open manpage in preview window
" - use clang_complete to open definition in preview window
" - Language-specific tag settings.
autocmd Filetype cpp
			\  nnoremap <buffer> K :call PreviewShell("man " . expand("<cword>"))<cr>
			\| nnoremap <buffer> <c-]> :FTStackPush<cr>:call g:ClangGotoDeclaration()<cr>
			\| nnoremap <buffer> <c-t> :FTStackPop<cr>
			\| nnoremap <buffer> <space>P :call g:ClangGotoDeclarationPreview()<cr>
			\| nnoremap <buffer> <space><c-p> :call PreviewLine("call g:ClangGotoDeclaration()")<cr>
			\| let b:paratags_lang_tags = "~/.vim/tags/cpptags"
			\| call ParaTagsLangAdd("/usr/include/c++/")

" ------------------------------------------------------------------------------
" - java_(filetype-specific)                                                   -
" ------------------------------------------------------------------------------
"
" This mostly assumes eclim

autocmd Filetype java
		\  inoremap <buffer> <c-@> <c-x><c-u>
		\| inoremap <buffer> <c-x><c-o> <c-x><c-u>
		\| nnoremap <buffer> <space>o :silent execute "!xterm -e eclimd &"<cr>
		\| nnoremap <buffer> <c-]> :FTStackPush<cr>:JavaSearchContext<cr>:autocmd! eclim_show_error<cr>
		\| nnoremap <buffer> <c-t> :FTStackPop<cr>
		\| nnoremap <buffer> <space>P :normal mP<cr>:pedit!<cr>:wincmd w<cr>:normal `P<cr>:JavaSearchContext<cr>:autocmd! eclim_show_error<cr>:wincmd w<cr>
		\| nnoremap <buffer> <space><c-p> :call PreviewLine("JavaSearchContext")<cr>
		\| nnoremap <buffer> K :JavaDocPreview<cr>

" ------------------------------------------------------------------------------
" - sh_(filetype-specific)                                                     -
" ------------------------------------------------------------------------------

" enable if/do/for folding
let g:sh_fold_enabled=4

" - Syntax highlight embedded awk.  Taken from syntax.txt, which took it from
"   Aaron Hope's aspperl.vim
autocmd Filetype sh if exists("b:current_syntax")
autocmd Filetype sh   unlet b:current_syntax
autocmd Filetype sh endif
autocmd Filetype sh syn include @AWKScript syntax/awk.vim
autocmd Filetype sh syn region AWKScriptCode matchgroup=AWKCommand start=+[=\\]\@<!'+ skip=+\\'+ end=+'+ contains=@AWKScript contained
autocmd Filetype sh syn region AWKScriptEmbedded matchgroup=AWKCommand start=+\<awk\>+ skip=+\\$+ end=+[=\\]\@<!'+me=e-1 contains=@shIdList,@shExprList2 nextgroup=AWKScriptCode
autocmd Filetype sh syn cluster shCommandSubList add=AWKScriptEmbedded
autocmd Filetype sh hi def link AWKCommand Type
" - open man page in preview window
autocmd Filetype sh nnoremap <buffer> K :call PreviewShell("man " . expand("<cword>"))<cr>

" ------------------------------------------------------------------------------
" - tex_(filetype-specific)                                                    -
" ------------------------------------------------------------------------------

" ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
" ~ general_options_(tex)                                                      ~
" ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
" Default to LaTeX, not Plain TeX/ConTeXt/etc
let g:tex_flavor='latex'

" ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
" ~ lualatex_highlighting_(tex)                                                ~
" ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
" - LuaTeX embeds Lua code into TeX documents.  The following code tells vim to
"   use Lua highlighting in the relevant sections within a TeX document.
" - custom mappings
" - Language-specific tag settings.
autocmd Filetype tex if exists("b:current_syntax") && b:current_syntax == "tex"
autocmd Filetype tex   unlet b:current_syntax
autocmd Filetype tex   syntax include @TEX syntax/tex.vim
autocmd Filetype tex   unlet b:current_syntax
autocmd Filetype tex   syntax include @LUA syntax/lua.vim
autocmd Filetype tex   syntax match texComment '%.*$' containedin=luatex contains=@texCommentGroup
autocmd Filetype tex   syntax region luatex matchgroup=Snip start='\\directlua{' end='}' containedin=@TEX contains=@LUA contains=@texComment
autocmd Filetype tex   highlight link Snip SpecialComment
autocmd Filetype tex   let b:current_syntax="luatex"
autocmd Filetype tex endif
			\| nnoremap <buffer> <space>o :silent execute "!mupdf " . expand("%:r").".pdf &"<cr>
			\| inoremap <buffer> <c-j> <ESC>:call LatexJump()<cr>
			\| inoremap <buffer> ;; <ESC>o\item<space>
			\| inoremap <buffer> ;' <ESC>o\item[]\hfill<cr><TAB><++><ESC>k0f[a
			\| inoremap <buffer> (( \left(\right)<++><ESC>10hi
			\| inoremap <buffer> [[ \left[\right]<++><ESC>10hi
			\| inoremap <buffer> {{ \left\{\right\}<++><ESC>11hi
			\| inoremap <buffer> __ _{}<++><ESC>4hi
			\| inoremap <buffer> ^^ ^{}<++><ESC>4hi
			\| inoremap <buffer> == &=
			\| inoremap <buffer> ;new \documentclass{}<cr>\begin{document}<cr><++><cr>\end{document}<ESC>3kf{a
			\| inoremap <buffer> ;use \usepackage{}<ESC>i
			\| inoremap <buffer> ;f \frac{}{<++>}<++><ESC>10hi
			\| inoremap <buffer> ;td \todo[]{}<esc>i
			\| inoremap <buffer> ;sk \sketch[]{}<esc>i
			\| inoremap <buffer> ;mi \begin{minipage}{.9\columnwidth}<cr>\end{minipage}<ESC>ko
			\| inoremap <buffer> ;al \begin{align*}<cr>\end{align*}<ESC>ko
			\| inoremap <buffer> ;mb \begin{bmatrix}<cr>\end{bmatrix}<ESC>ko
			\| inoremap <buffer> ;mp \begin{pmatrix}<cr>\end{pmatrix}<ESC>ko
			\| inoremap <buffer> ;li \begin{itemize}<cr>\end{itemize}<ESC>ko\item<space>
			\| inoremap <buffer> ;le \begin{enumerate}<cr>\end{enumerate}<ESC>ko\item<space>
			\| inoremap <buffer> ;ld \begin{description}<cr>\end{description}<ESC>ko\item[]\hfill<cr><tab><++><ESC>k0f[a
			\| inoremap <buffer> ;ca \begin{cases}<cr>\end{cases}<ESC>ko
			\| inoremap <buffer> ;tb \begin{tabular}{llllllllll}<cr>\end{tabular}<ESC>ko\toprule<cr>\midrule<cr>\bottomrule<ESC>kko
			\| inoremap <buffer> ;ll \begin{lstlisting}<cr>\end{lstlisting}<ESC>ko
			\| inoremap <buffer> ;df \begin{definition}[]<cr>\end{definition}<ESC>ko<++><esc>k0f[a
			\| inoremap <buffer> ;xp \begin{example}[]<cr>\end{example}<ESC>ko<++><esc>k0f[a
			\| inoremap <buffer> ;sl \begin{solution}<cr>\end{solution}<ESC>ko<++><esc>k0f[a
			\| vnoremap <buffer> ;u <esc>`>a}_{}<++><esc>`<i\underbrace{<esc>`>2f}i
			\| vnoremap <buffer> ;U <esc>`>a}}_{}$<++><esc>`<i$\underbrace{\text{<esc>`>3f}i
			\| vnoremap <buffer> ;o <esc>`>a}^{}<++><esc>`<i\overbrace{<esc>`>2f}i
			\| vnoremap <buffer> ;O <esc>`>a}}^{}$<++><esc>`<i$\overbrace{\text{<esc>`>3f}i
			\| nnoremap <buffer> <space>& :Tab /&<cr>
			\| xnoremap <buffer> <space>& :Tab /&<cr>
			\| nnoremap <buffer> <space>\ :Tab /\\\\<cr>
			\| xnoremap <buffer> <space>\ :Tab /\\\\<cr>
			\| let b:paratags_lang_tags = "~/.vim/tags/latextags"
			\| call ParaTagsLangAdd("/usr/share/textmf-texlive/tex/latex/")
			\| call ParaTagsLangAdd("/usr/share/texmf/tex/latex/")
			\| call ParaTagsLangAdd("~/texmf/tex/latex/")
			\| call ParaTagsLangAdd("~/.texmf/tex/latex/")
" Tabularize Automatically
" Disabled as more troublesome than helpful
"au Filetype tex inoremap & &<Esc>:let columnnum=<c-r>=strlen(substitute(getline('.')[0:col('.')],'[^&]','','g'))<cr><cr>:Tabularize /&<cr>:normal 0<cr>:normal <c-r>=columnnum<cr>f&<cr>a

" ------------------------------------------------------------------------------
" - markdown_(filetype-specific)                                               -
" ------------------------------------------------------------------------------
"
" override modula2 default for .md files
autocmd BufNewFile,BufRead *.md set ft=markdown

" ------------------------------------------------------------------------------
" - dot_(filetype-specific)                                                    -
" ------------------------------------------------------------------------------
"
" treat .gv files as dot
autocmd BufNewFile,BufRead *.gv set ft=dot
autocmd Filetype dot
			\ nnoremap <buffer> <space>o :silent execute "!sxiv -s -V " . expand("%:r").".png &"<cr>

" ------------------------------------------------------------------------------
" - other_(filetype-specific)                                                  -
" ------------------------------------------------------------------------------
"
" If a filetype doesn't have it's own omnicompletion, but it does have syntax
" highlighting, use that for omnicompletion

autocmd Filetype *
			\  if &omnifunc == ""
			\|   setlocal omnifunc=syntaxcomplete#Complete
			\| endif


" ==============================================================================
" = plugin_settings                                                            =
" ==============================================================================

" If available, have pathogen load plugins form ~/.vim/bundle.
if filereadable($HOME . "/.vim/autoload/pathogen.vim")
	" disable plugins that have missing prerequisites
	let g:pathogen_disabled = []
	if !isdirectory("/usr/include/clang")
		let g:pathogen_disabled += ['clang_complete']
	endif
	call pathogen#runtime_append_all_bundles()
	call pathogen#helptags()
endif
" Enable filetype-specific plugins.
filetype plugin on
" Utilize filetype-specific automatic indentation.
filetype indent on

" ------------------------------------------------------------------------------
" - ParaTags_(plugins)                                                         -
" ------------------------------------------------------------------------------

execute "set tags+=" . g:tmpdir . ".vim-tags-".getpid()
autocmd VimLeave * call delete(g:tmpdir . ".vim-tags-".getpid())

" ------------------------------------------------------------------------------
" - SkyBison_(plugins)                                                         -
" ------------------------------------------------------------------------------

let g:skybison_fuzz = 2

" ------------------------------------------------------------------------------
" - jedi_(plugins)                                                             -
" ------------------------------------------------------------------------------
" jedi has some uses, but the defaults are terribly intrusive

let g:jedi#use_tabs_not_buffers = 0
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0
let g:jedi#completions_command = "<leader>zzz"
let g:jedi#auto_vim_configuration = 0
let g:jedi#show_call_signatures = 0

" ------------------------------------------------------------------------------
" - clang_complete_(plugins)                                                   -
" ------------------------------------------------------------------------------

" do not automatically pop up completion after a ->, ., or ::
let g:clang_complete_auto = 0

" do not have the clang plugin set mappings, as it makes some disagreeable
" choices.  Do it directly in the .vimrc file.
let g:clang_make_default_keymappings = 0


" ------------------------------------------------------------------------------
" - LanguageTool_(plugins)                                                     -
" ------------------------------------------------------------------------------

" Indicate where the LanguageTool jar is located
let g:languagetool_jar='/opt/languagetool/languagetool-commandline.jar'

" ------------------------------------------------------------------------------
" - eclim_(plugins)                                                            -
" ------------------------------------------------------------------------------

" disable automatic linting on write
"call manually with: call eclim#lang#UpdateSrcFile('java',1)
let g:EclimJavaValidate = 0
" With JavaSearch/JavaSearchContextalways jump to definition in current window
let g:EclimJavaSearchSingleResult = 'edit'

" ==============================================================================
" = custom_functions                                                           =
" ==============================================================================

" ------------------------------------------------------------------------------
" - make_(functions)                                                           -
" ------------------------------------------------------------------------------
"
" Function to figure out specifics for what to compile with :make based on
" filetype and context

command! Make :call Make()
function! Make()
	" First, save buffer.  It is unlikely the user will want to compile a
	" non-current version when the compile is requested, and it is likely that
	" the user could forget to save before calling this.
	w
	" Move the directory containing the current buffer.  This is helpful in
	" case multiple buffers are open which have different associated
	" Makefiles.
	execute "cd " . expand("%:p:h")
	" Set the 'makeprg', 'errorformat'.  Three possibilities:
	" 1. If there is a g:makeprg, probably project-specific make instructions,
	" use that
	" 2. Otherwise, if there is a Makefile in the pwd, use that (i.e. vim
	" default)
	" 3. Otherwise, use a filetype-specific compiler/linter
	if exists("g:makeprg")
		execute "setlocal makeprg=" . escape(g:makeprg, " \\")
		if exists("g:errorformat")
			execute "setlocal errorformat=" . escape(g:errorformat, " \\")
		endif
	elseif filereadable("./Makefile") || filereadable("./makefile")
		setlocal makeprg&vim
		setlocal errorformat&vim
	elseif &ft == "c"
		setlocal makeprg=gcc\ -Wall\ %
		setlocal errorformat&vim
	elseif &ft == "cpp"
		setlocal makeprg=g++\ -Wall\ %
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
		call CCOnError()
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
	call CCOnError()
endfunction

" ------------------------------------------------------------------------------
" - run_(functions)                                                           -
" ------------------------------------------------------------------------------
"
" Try to make an educated guess on what to run given the current filetype and
" context.  Also helps set executable if needed.

command! Run :call Run("sh")
function! Run(type)
	" Move the directory containing the current buffer.  This is helpful in
	" case multiple buffers are open which have different associated
	" ./a.out or equivalent
	execute "cd " . expand("%:p:h")
	" Determine what to run
	let l:quiet = 0
	if exists("g:runcmd")
		let l:runcmd = g:runcmd
	elseif &ft == "c"
		let l:runpath = "./a.out"
		let l:runcmd = l:runpath
	elseif &ft == "cpp"
		let l:runpath = "./a.out"
		let l:runcmd = l:runpath
	elseif &ft == "java"
		" assumes eclim
		autocmd! eclim_java
		autocmd! eclim_show_error
		let l:project = eclim#project#util#GetCurrentProjectName()
		let l:runcmd = "eclim -editor vim -command java -p " . l:project
	elseif &ft == "python"
		let l:runpath = expand("%:p")
		let l:runcmd = l:runpath
	elseif &ft == "sh"
		let l:runpath = expand("%:p")
		let l:runcmd = l:runpath
	elseif &ft == "tex"
		" reload pdf reader
		let l:runcmd = "pkill -HUP mupdf"
		let l:quiet = 1
	elseif &ft == "dot"
		" reload image viewer
		let l:runcmd = "xdotool search --name sxiv key r"
		let l:quiet = 1
	endif

	if exists("l:runpath") && !filereadable(l:runpath)
		echohl ErrorMsg
		echo "Run: Could not find file at \"" . l:runpath . "\""
		echohl None
		return
	endif

	if exists("l:runpath") && !executable(l:runpath)
		redraw!
		echo "Set " . runpath . " as executable? (y/n) "
		if nr2char(getchar()) == "y"
			call system("chmod u+x " . l:runpath)
		else
			return
		endif
	endif

	if a:type == "sh" && !l:quiet
		silent! :!clear
		redraw!
		execute "!" . l:runcmd
	elseif a:type == "sh" && l:quiet
		call system(l:runcmd . "&")
	elseif a:type == "preview"
		call PreviewShell(l:runcmd)
	elseif a:type == "xterm"
		if exists("g:last_run_pid")
			echo system('kill ' . g:last_run_pid . " >/dev/null 2>&1")
		endif
		let g:last_run_pid = system('xterm -e sh -c "' . l:runcmd . '; echo; echo RETURNED $?; echo PRESS ENTER TO CLOSE; read PAUSE" & echo $!')
	endif
	return
endfunction

" ------------------------------------------------------------------------------
" - latexjump()_(functions)                                                    -
" ------------------------------------------------------------------------------
"
" Jumps to next <++>.  Conceptually based on vim-latexsuite's equivalent.

function! LatexJump()
	if search('<++>') == 0
		normal! l
		startinsert
	else
		execute "normal! v3l\<c-g>"
	endif
endfunction

" ------------------------------------------------------------------------------
" - latexenv()_(functions)                                                     -
" ------------------------------------------------------------------------------
"
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

" ------------------------------------------------------------------------------
" - parajump()_(functions)                                                     -
" ------------------------------------------------------------------------------
"
" A direction 'j' or 'k' is specified.
" If the next move in that direction moves the cursor over whitespace, continue
" moving in the specified direction until the cursor is no longer on
" whitespace.
" If the cursor is on whitespace, move in the specified direction until the
" If the next move in that direction moves the cursor over non-whitespace,
" continue moving in the specified direction until the cursor moves over
" whitespace.

nnoremap <space>j :call ParaJump('j')<cr>
nnoremap <space>k :call ParaJump('k')<cr>
function! ParaJump(direction)
	if a:direction == 'j'
		let delta = 1
	elseif a:direction == 'k'
		let delta = -1
	else
		echohl ErrorMsg
		echo "ParaJump: Illegal direction specified"
		echohl None
		return -1
	endif

	" get starting line number
	let line = line(".")

	" check if the cursor is on whitespace or not
	function! l:CharWhitespace(line)
		return stridx(" \t", getline(a:line)[col(".")-1]) != -1
	endfunction

	" "move" once to start
	let line += delta

	" get starting whitespace/non-whitespace info.
	let inittype = l:CharWhitespace(line)

	while l:CharWhitespace(line) == inittype && line < line("$") && line > 1
		let line += delta
	endwhile

	" purposefully using G here to make a jump break
	execute "normal " . line . "G"
endfunction

" ------------------------------------------------------------------------------
" - createcommentheading()_(functions)                                         -
" ------------------------------------------------------------------------------
"
" Create headings in comments

function! CreateCommentHeading(level)
	setlocal paste
	for iteration in [1,2]
		exec "normal! o" . b:commentcharacters . " "
		if a:level == 1
			exec "normal a" . repeat("=",79 - len(b:commentcharacters))
		elseif a:level == 2
			exec "normal a" . repeat("-",79 - len(b:commentcharacters))
		elseif a:level == 3
			exec "normal a" . repeat("~ ",float2nr(floor(79 - len(b:commentcharacters))/2))
		endif
	endfor
	exec "normal! O" . b:commentcharacters . " "
	if a:level == 1
		exec "normal a=" . repeat(" ",77 - len(b:commentcharacters)) . "="
		normal F=ll
	elseif a:level == 2
		exec "normal a-" . repeat(" ",77 - len(b:commentcharacters)) . "-"
		normal F-ll
	elseif a:level == 3
		exec "normal a~" . repeat(" ",77 - len(b:commentcharacters)) . "~"
		normal F~ll
	endif
	setlocal nopaste
	startreplace
endfunction

" ------------------------------------------------------------------------------
" - ParaTags()_(functions)                                                     -
" ------------------------------------------------------------------------------
"
" code to generate tag files

" This function generates tags for open buffers.  This is fast enough to do
" before every call to use a tag.  The effect is the same as having any file
" altered in the given Vim session has its tags updated automatically.
nnoremap <c-]> :call ParaTagsBuffers()<cr><c-]>
nnoremap <space>P :call ParaTagsBuffers()<cr><c-w>}
nnoremap <space><c-p> :call ParaTagsBuffers()<cr>:call PreviewLine("normal <c-]>")<cr>
function! ParaTagsBuffers()
	redraw
	echo "ParaTagsBuffers working..."
	let l:buffertagfile = g:tmpdir . ".vim-tags-" . getpid()
	if filereadable(l:buffertagfile)
		call delete(l:buffertagfile)
	endif
	for l:buffer_number in range(1,bufnr("$"))
		if buflisted(l:buffer_number)
			let l:buffername = bufname(l:buffer_number)
			if l:buffername[0] != "/"
				let l:buffername = getcwd()."/".l:buffername
			endif
			call system("ctags -a -f ".l:buffertagfile." --language-force=".GetCtagsFiletype(getbufvar(l:buffer_number,"&filetype"))." ".l:buffername)
		endif
	endfor
	redraw
	echo "ParaTagsBuffers Done"
endfunction

" This function will generate tags for the libraries in a given language.  Note
" that some languages have huge libraries and this could take a while
function! ParaTagsLangGen()
	echo "ParaTagsLanguage working..."
	if exists("b:paratags_lang_tags") && exists("b:paratags_lang_sources")
		call system("mkdir -p ~/.vim/tags/")
		call system("ctags -R -f " . b:paratags_lang_tags . " " . join(b:paratags_lang_sources))
	endif
	redraw
	echo "ParaTagsBuffers Done"
endfunction

" This function adds a source
function! ParaTagsLangAdd(source)
	if !exists("b:paratags_lang_sources")
		let b:paratags_lang_sources = []
	endif
	if index(b:paratags_lang_sources, a:source)
		let b:paratags_lang_sources += [a:source]
	endif
endfunction

" This enables the language library tags
function! ParaTagsLangEnable()
	if exists("b:paratags_lang_tags")
		execute "set tags +=" . b:paratags_lang_tags
	endif
endfunction

" This disables the language library tags
function! ParaTagsLangDisable()
	if exists("b:paratag_lang_tags")
		execute "set tags -=" . b:paratag_lang_tags
	endif
endfunction

" ------------------------------------------------------------------------------
" - getctagsfiletype()_(functions)                                             -
" ------------------------------------------------------------------------------
"
" maps vim's filetype to corresponding ctag's filetype
" used by ParaTagsBuffers()

function! GetCtagsFiletype(vimfiletype)
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

" ------------------------------------------------------------------------------
" - quick_fix_signs                                                            -
" ------------------------------------------------------------------------------
" populate the sign column based on quickfix results

function! QuickFixSigns()
	sign define warning text=WW texthl=Error
	sign define error text=EE texthl=Error
	sign define convention text=CC texthl=Error
	sign define misc text=>> texthl=Error
	sign unplace *
	let qflines = []
	for item in getqflist()
		if item['bufnr'] != 0
			if item['text'][0] == 'E' || item['text'][1] == 'E'
				execute "sign place 1 line=" . item['lnum'] . " name=error buffer=" . item['bufnr']
			elseif item['text'][0] == 'W' || item['text'][1] == 'W'
				execute "sign place 1 line=" . item['lnum'] . " name=warning buffer=" . item['bufnr']
			elseif item['text'][0] == 'W' || item['text'][1] == 'C'
				execute "sign place 1 line=" . item['lnum'] . " name=convention buffer=" . item['bufnr']
			else
				execute "sign place 1 line=" . item['lnum'] . " name=misc buffer=" . item['bufnr']
			endif
		endif
	endfor
endfunction
augroup signs
	autocmd QuickFixCmdPost * call QuickFixSigns()
augroup END

" ------------------------------------------------------------------------------
" - grepbuffers                                                                -
" ------------------------------------------------------------------------------
" grep through buffers

command! -nargs=* G :call GrepBuffers("<args>")
function! GrepBuffers(arg)
	let initbufnr = bufnr("%")
	call setqflist([])
	for b in range(1,bufnr("$"))
		if buflisted(b)
			execute "b " . b
			normal gg
			while searchpos(a:arg, 'W') != [0,0]
				call setqflist([{'bufnr': b, 'lnum': line("."), 'col': col("."), 'text': getline(".")}], 'a')
			endwhile
		endif
	endfor
	execute "b " . initbufnr
	call CCOnError()
endfunction

" ------------------------------------------------------------------------------
" - cc_on_error                                                                -
" ------------------------------------------------------------------------------
" run after attempting to populate quickfixlist
" if quickfix has something, jump to first item

function! CCOnError()
	redraw
	for error in getqflist()
		if error['bufnr'] != 0
			cc
			return
		endif
	endfor
	echo 'no errors/results'
endfunction

" ------------------------------------------------------------------------------
" - preview_shell                                                              -
" ------------------------------------------------------------------------------
" Run the provided command on the shell and open the output in the preview
" window

function! PreviewShell(cmd)
	pclose  " so we don't get W11
	execute "silent !" . a:cmd . " > " . g:tmpdir . ".vimshellout-" . getpid()
	execute "pedit! /dev/shm/.vimshellout-" .getpid()
	wincmd P
	setlocal bufhidden=delete
	autocmd VimLeave * call delete(g:tmpdir . ".vimshellout-".getpid())
	wincmd p
	redraw!
endfunction

" ------------------------------------------------------------------------------
" - thesaurus                                                                  -
" ------------------------------------------------------------------------------

" have i_ctrl-x_ctrl-t grab synonyms from thesaurus.com if doesn't exist
" locally
inoremap <c-x><c-t> <c-o>:call Thesaurus(expand("<cword>"))<cr><c-x><c-t>
" Ensure desired word is in local thesaurus
function! Thesaurus(word)
	" check if given word is already in local thesaurus
	if filereadable(g:thesaurusfile)
		for line in readfile(g:thesaurusfile)
			if match(line, "^" . a:word . " ") != -1
				return
			endif
		endfor
	endif

	" we don't yet have the word, get the thesaurus.com page
	let out = g:tmpdir . ".vim-thesaurus-out-" . getpid()
	execute "autocmd VimLeave * call delete(\"".out."\")"
	echo "Looking up \"" . a:word . "\"..."
	silent! execute "silent !wget -qO " . out . " http://thesaurus.com/browse/" . a:word
	if !filereadable(out)
		redraw!
		echohl ErrorMsg
		echo "Could not find " . a:word . " at thesaurus.com"
		echohl None
		call input("ENTER to continue")
		return
	endif

	" parse page for synonyms
	let results = []
	for line in readfile(out)
		let fields = split(line, "\<\\|\>\\|&quot;")
		if len(fields) > 2 && fields[1] == 'span class="text"'
			let results += [fields[2]]
		endif
	endfor

	" append synonyms to local thesaurus
	if filereadable(g:thesaurusfile)
		let thesaurus = readfile(g:thesaurusfile)
	else
		let thesaurus = []
	endif
	let thesaurus += [a:word . ' ' . join(results)]
	call writefile(thesaurus, g:thesaurusfile)
	redraw!
endfunction
" open synonyms in preview window
command! -nargs=1 Thesaurus :call PreviewThesaurus("<args>")
nnoremap g<c-t> :call PreviewThesaurus(expand("<cword>"))<cr>
function! PreviewThesaurus(word)
	call Thesaurus(a:word)
	let found = 0
	for line in readfile(g:thesaurusfile)
		let fields = split(line)
		if fields[0] == a:word
			let found = 1
			break
		endif
	endfor
	if !found
		echo "No matches"
		return
	endif
	let out = "/dev/shm/.vim-synonyms-".getpid()
	execute "autocmd VimLeave * call delete(\"".out."\")"
	call writefile([line], out)
	execute "pedit! " . out
	wincmd P
	setlocal nomodifiable
	normal gg
	setlocal bufhidden=delete
	redraw!
endfunction

" ------------------------------------------------------------------------------
" - dictionary                                                                 -
" ------------------------------------------------------------------------------
" If word is not in local dictionary, gets it from dictionary.com.  Then
" displays it in preview window.

nnoremap g<c-d> :call Dictionary(expand("<cword>"))<cr>
command! -nargs=1 Dictionary :call Dictionary("<args>")
function! Dictionary(word)
	" Check if given word is already in local dictionary.  If so, store it in "line"
	let defline = ""
	let found = 0
	if filereadable(g:dictionaryfile)
		for line in readfile(g:dictionaryfile)
			if match(line, "^" . a:word . "|") != -1
				let defline = line
				break
			endif
		endfor
	endif
	echo defline

	" we don't yet have the word, get the dictionary.com page
	if defline == ""
		let out = g:tmpdir  . ".vim-dictionary-out-" . getpid()
		execute "autocmd VimLeave * call delete(\"".out."\")"
		redraw
		echo "Looking up \"" . a:word . "\"..."
		silent! execute "silent !wget -qO " . out . " http://dictionary.com/browse/" . a:word
		if !filereadable(out)
			redraw!
			echohl ErrorMsg
			echo "Could not find " . a:word . " at dictionary.com"
			echohl None
			call input("ENTER to continue")
			return
		endif

		" parse page for definitions
		function! l:fmt(inline, indent)
				let line = a:inline
				let line = substitute(line, '   *', ' ', 'g')
				let line = substitute(line, '<[^>]\+>', '', 'g')
				let line = substitute(line, '^[ \t\r\n]*', '', 'g')
				if line =~ "^[ \t\r\n]*$"
					return ""
				endif
				return "|" . a:indent . line
		endfunction
		let defline = a:word
		let last_line = ""
		let in_sublist = 0
		for line in readfile(out)
			" synonyms are put in an awkward place, just remove them
			if match(line, "def-block-label-synonyms") != -1
				let line = substitute(line, '<[^>]*def-block-label-synonyms.*', '', 'g')
			endif
			" pronunciation
			if match(line, "spellpron") != -1
				let defline .= l:fmt(line, "")
			endif
			" part of speech
			if match(line, "dbox-pg") != -1
				let defline .= l:fmt(line, "")
			endif
			" definition number
			if match(line, "def-number") != -1
				let defline .= l:fmt(line, "")
			endif
			" definition
			if match(last_line, "def-content") != -1
				let defline .= l:fmt(line, "  ")
			endif
			" sub-definition
			if match(last_line, "def-sub-list") != -1
				let in_sublist = 1
			endif
			if match(last_line, "<li>") != -1 && in_sublist
				let defline .= l:fmt(line, "  - ")
			endif
			if match(last_line, "</ol>") != -1
				let in_sublist = 0
			endif
			let last_line = line
		endfor

		" append synonyms to local dictionary
		if filereadable(g:dictionaryfile)
			let dictionary = readfile(g:dictionaryfile)
		else
			let dictionary = []
		endif
		let dictionary += [defline]
		call writefile(dictionary, g:dictionaryfile)
	endif
	
	" show definition in preview window
	let fmt = split(defline,"|")
	let out = g:tmpdir . ".vim-definition-".getpid()
	execute "autocmd VimLeave * call delete(\"".out."\")"
	call writefile(fmt, out)
	execute "pedit! " . out
	wincmd P
	setlocal nomodifiable
	normal gg
	setlocal bufhidden=delete
	redraw!
endfunction

" ------------------------------------------------------------------------------
" - Fake_Tag_Stack                                                             -
" ------------------------------------------------------------------------------
"
" Mimics the tag stack for tools that have jump-to-definition without using
" tags

command! FTStackPush :call FTStackPush()
function! FTStackPush()
	if !exists("g:ftstack")
		let g:ftstack = []
	endif
	let g:ftstack += [[expand("%"), line("."), virtcol(".")]]
endfunction

command! FTStackPop :call FTStackPop()
function! FTStackPop()
	if !exists("g:ftstack") || len(g:ftstack) == 0
		redraw
		echo "Tag Stack Empty"
		return
	endif
	execute "e " . g:ftstack[-1][0]
	execute "normal " . g:ftstack[-1][1] . "G"
	execute "normal " . g:ftstack[-1][2] . "|"
	let g:ftstack = g:ftstack[:-2]
endfunction

" ------------------------------------------------------------------------------
" - diffsigns                                                                  -
" ------------------------------------------------------------------------------

set diffexpr=DiffSigns()
function! DiffSigns()
	" setup signs
	sign define added   text=++ texthl=DiffAdd
	sign define deleted text=-- texthl=DiffDelete
	sign define changed text=!! texthl=DiffChange
	sign unplace *
	" setup diff
	let opt = ""
	if &diffopt =~ "icase"
		let opt = opt . "-i "
	endif
	if &diffopt =~ "iwhite"
		let opt = opt . "-b "
	endif
	" run diff
	silent execute "!diff -a --binary " . opt . v:fname_in . " " . v:fname_new . " > " . v:fname_out

	" pre-parse diff to find which buffer was "fname_in" and which buffer was "fname_new"
	" 0 means we don't have any idea
	" <0 means we know if there's only two diff windows, but if not we could still be wrong, keep look
	" >0 means we found it
	let in_buf = 0
	let new_buf = 0
	for line in readfile(v:fname_out)
		" we only care about the lines that tell us which lines were changed, not the actual changes
		if line !~ "^[0-9]"
			continue
		endif
		let in_side = split(line, "[acd]")[0] " A,B
		let new_side = split(line, "[acd]")[1] " C,D"
		let changetype = split(line, "[0-9,]")[0] "c"
		if in_side =~ ","
			let in_start = split(in_side, ",")[0]
		else
			let in_start = in_side
		endif
		if new_side =~ ","
			let new_start = split(new_side, ",")[0]
		else
			let new_start = new_side
		endif
		if changetype == "a"
			let new_line = readfile(v:fname_new)[new_start-1]
			for win in range(1, winnr("$"))
				if getwinvar(win, '&diff')
					if getbufline(winbufnr(win),new_start)[0] == new_line
						let new_buf = winbufnr(win)
					else
						if in_buf == 0
							let in_buf = -winbufnr(win)
						endif
					endif
				endif
			endfor
		elseif changetype == "d"
			let in_line = readfile(v:fname_in)[in_start-1]
			for win in range(1, winnr("$"))
				if getwinvar(win, '&diff')
					if getbufline(winbufnr(win),in_start)[0] == in_line
						let in_buf = winbufnr(win)
					else
						if new_buf == 0
							let new_buf = -winbufnr(win)
						endif
					endif
				endif
			endfor
		elseif changetype == "c"
			let new_line = readfile(v:fname_new)[new_start-1]
			for win in range(1, winnr("$"))
				if getwinvar(win, '&diff')
					if getbufline(winbufnr(win),new_start)[0] == new_line
						let new_buf = winbufnr(win)
						break
					endif
				endif
			endfor
			let in_line = readfile(v:fname_in)[in_start-1]
			for win in range(1, winnr("$"))
				if getwinvar(win, '&diff')
					if getbufline(winbufnr(win),in_start)[0] == in_line
						let in_buf = winbufnr(win)
						break
					endif
				endif
			endfor
		endif
		if new_buf > 0 && in_buf > 0
			break
		endif
	endfor

	if new_buf < 0
		" couldn't find it for sure, but we've probably got it
		let new_buf *= -1
	endif
	if in_buf < 0
		" couldn't find it for sure, but we've probably got it
		let in_new *= -1
	endif
	if new_buf == 0 || in_buf == 0
		echohl ErrorMsg
		echo "DiffSigns: Could not find both diff windows"
		echohl None
	endif

	for line in readfile(v:fname_out)
		" we only care about the lines that tell us which lines were changed, not the actual changes
		if line !~ "^[0-9]"
			continue
		endif
		let in_side = split(line, "[acd]")[0]
		let new_side = split(line, "[acd]")[1]
		let changetype = split(line, "[0-9,]")[0]
		if in_side =~ ","
			let in_start = split(in_side, ",")[0]
			let in_end = split(in_side, ",")[1]
		else
			let in_start = in_side
			let in_end = in_side
		endif
		if new_side =~ ","
			let new_start = split(new_side, ",")[0]
			let new_end = split(new_side, ",")[1]
		else
			let new_start = new_side
			let new_end = new_side
		endif
		if changetype == "a"
			let new_signtype = "added"
			let in_signtype = "deleted"
		elseif changetype == "d"
			let new_signtype = "deleted"
			let in_signtype = "added"
		elseif changetype == "c"
			let new_signtype = "changed"
			let in_signtype = "changed"
		else
			let new_signtype = "???"
			let in_signtype = "???"
		endif
		for linenr in range(new_start, new_end)
			if new_signtype != "deleted" && new_buf != ""
				execute "sign place 1 line=" . linenr . " name=" . new_signtype . " buffer=" . new_buf
			endif
		endfor
		for linenr in range(in_start, in_end)
			if in_signtype != "deleted" && in_buf != ""
				execute "sign place 1 line=" . linenr . " name=" . in_signtype . " buffer=" . in_buf
			endif
		endfor
	endfor
endfunction

" ------------------------------------------------------------------------------
" - signmarks                                                                  -
" ------------------------------------------------------------------------------

" show marks in sign column
nnoremap <space>M :call SignMarks()<cr>
function! SignMarks()
	sign unplace *
	for mark in ["}","{",")","(","`",".","^",'"',"'",">","<","]","[" ,"9","8","7","6","5","4","3","2","1","0","Z","Y","X","W","V","U","T","S","R","Q","P","O","N","M","L","K","J","I","H","G","F","E","D","C","B","A" ,"z","y","x","w","v","u","t","s","r","q","p","o","n","m","l","k","j","i","h","g","f","e","d","c","b","a"]
		let char = mark
		let pos = getpos("'" . char)
		if pos != [0,0,0,0]
			if pos[0] != 0
				let bufnr = pos[0]
			else
				let bufnr = bufnr("%")
			endif
			execute "sign define mark" . char . " text='" . char . " texthl=NonText"
			execute "sign place 1 line=" . pos[1] . " name=mark" . char . " buffer=" . bufnr
		endif
	endfor
endfunction

" ------------------------------------------------------------------------------
" - togglecomment                                                              -
" ------------------------------------------------------------------------------

xnoremap <silent> <c-n> :call ToggleComment()<cr>
nnoremap <silent> <c-n> :call ToggleComment()<cr>
function! ToggleComment()
	" Determine comment character(s) based on filetype.  Vim sets &commentstring
	" to the relevant value, but also include '%s' which we want to strip out.
	let b:commentcharacters = substitute(&commentstring,"%s","","")
	" The way this function is designed, multi-line comments don't work.  For
	" C-style languages, use // ... instead of /* ... */
	if b:commentcharacters == "/**/"
		let b:commentcharacters = "//"
	endif
	if getline(".") =~ "^" . b:commentcharacters . " "
		" line is commented, uncomment
		execute "s,^" . b:commentcharacters . " ,,e"
		nohlsearch
	else 
		" line is not commented, comment it
		execute "s,^," . b:commentcharacters . " ,"
		nohlsearch
	endif
endfunction

" ------------------------------------------------------------------------------
" - session_management                                                         -
" ------------------------------------------------------------------------------

nnoremap <c-k>w :call SessionSave()<cr>
nnoremap <c-k>l :call SessionLoad()<cr>

command! -nargs=1 SessionSave :call SessionSave("<args>")
function! SessionSave(...)
	" if it looks like maybe the user wanted to load, not save, be careful
	" not to overwrite with blank project
	if bufname("%") == ""
		redraw
		echohl ErrorMsg
		echo "Refusing to overwrite when current buffer is unnamed"
		echohl None
		return
	endif

	" get name for session
	if a:0 == 0
		let name = input("Save Session Name: ")
	else
		let name = a:1
	endif

	" If we're in a git-managed project, save symlink to git project and
	" actual session info in .git as branch name.
	"
	" Otherwise, save session info normally.
	let git_top = system("git rev-parse --show-toplevel")[:-2]
	if git_top[0] == "/"
		" make symlink to git project
		call system("mkdir -p " . $HOME . "/.vim/sessions")
		call system("ln -s '" . git_top . "' " . $HOME . "/.vim/sessions/" . name)
		" make session file at .git/vimsessions/branch-name
		let branch = system("git branch | awk '$1==\"*\"{print$2}'")[:-2]
		let session_path = git_top . "/.git/vimsessions/" . branch
		call system("mkdir -p " . git_top . "/.git/vimsessions")
		execute "mksession!  " . session_path
		redraw
		echo "Saved Session \"" . name . "\" (" . branch . ")"
	else
		" make session file at ~/.vim/sessions
		call system("mkdir -p " . $HOME . "/.vim/sessions")
		let session_path = $HOME . "/.vim/sessions/" . name
		execute "mksession!  " . session_path
		redraw
		echo "Saved Session \"" . name . "\""
	endif

	" auto-update session just before leaving vim
	let g:session_name = name
	augroup session
		autocmd!
		autocmd VimLeavePre * if bufname("%") != "" | call SessionSave(g:session_name) | endif
	augroup END
endfunction

command! -nargs=1 -complete=customlist,SessionList SessionLoad :call SessionLoad("<args>")
function! SessionList(A,L,P)
	if a:A[-1:] != "*"
		let globpattern = a:A . "*"
	else
		let globpattern = a:A
	endif
	let sessions = []
	for session in split(globpath($HOME . "/.vim/sessions", globpattern),'\n')
		let sessions += [fnamemodify(session, ":t")]
	endfor
	return sessions
endfunction
function! SessionLoad(...)
	" get name for session
	if a:0 == 0
		let name = input("Load Session Name: ")
	else
		let name = a:1
	endif

	" Check if session exists
	let session_path = $HOME . "/.vim/sessions/" . name
	if system("[ -e " . session_path . " ]; echo $?") == 1
		redraw
		echohl ErrorMsg
		echo "Cannot find session \"" . name . "\""
		echohl None
		return
	endif

	" If target is symlink, session file is stored in $SYMLINK/.git/$BRANCH
	" Otherwise session file is at target
	let branch = ""
	if system("[ -h " . session_path . " ]; echo $?") == 0
		exec "cd " . session_path
		let branch = system("git branch | awk '$1==\"*\"{print$2}'")[:-2]
		let session_path = "./.git/vimsessions/" . branch
		execute "source " . session_path
	endif

	" auto-update session just before leaving vim
	let g:session_name = name
	augroup session
		autocmd! session
		autocmd VimLeavePre * if bufname("%") != "" | call SessionSave(g:session_name) | endif
	augroup END

	execute "source " . session_path
	redraw
	if branch == ""
		echo "Loaded Session \"" . name . "\""
	else
		echo "Loaded Session \"" . name . "\" (" . branch . ")"
	endif
endfunction


" ------------------------------------------------------------------------------
" - switchheader                                                               -
" ------------------------------------------------------------------------------
"
" switch between c/cpp file and corresponding header

command! SwitchHeader :call SwitchHeader()
function! SwitchHeader()
	let filebase = expand("%:t:r")
	" Add extra dir layer here so the while loop below will start at the
	" proper place, since there's no do/while.
	let dirbase = expand("%:p:h") . "/"
	let extension = expand("%:t:e")
	if extension == "h"
		let targets = [".c", ".cpp", ".C", ".cc", "cxx"]
	else
		let targets = [".h", ".hh", ".hxx", ".hpp"]
	endif
	while dirbase != "/"
		let dirbase = fnamemodify(dirbase, ":h")
		for target in targets
			for subdir in ["", "c/", "include/"]
				let p = dirbase . "/" . subdir . filebase . target
				if filereadable(p)
					exec ":e " . p
					return
				endif
			endfor
		endfor
	endwhile
	redraw
	echohl ErrorMsg
	echo "Could not find header"
	echohl None
endfunction

" ------------------------------------------------------------------------------
" - switchheader                                                               -
" ------------------------------------------------------------------------------
"
" Save a list of 'favorite' files to be able to reach quickly

command! -nargs=1 MarkFile :call SetMarkFile("<args>")
function! SetMarkFile(mark)
	call system("mkdir -p " . $HOME . "/.vim/filemarks")
	call system("ln -s '" . expand("%:p") . "' " . $HOME . "/.vim/filemarks/" . a:mark)
endfunction

command! -nargs=1 -complete=customlist,ListFileMarks F :call GetMarkFile("<args>")
function! ListFileMarks(A,L,P)
	if a:A[-1:] != "*"
		let globpattern = a:A . "*"
	else
		let globpattern = a:A
	endif
	let filemarks = []
	for filemark in split(globpath($HOME . "/.vim/filemarks",globpattern),'\n')
		let filemarks += [fnamemodify(filemark, ":t")]
	endfor
	return filemarks
endfunction
function! GetMarkFile(mark)
	" read the link and edit the actual place instead of editing the link
	" so vim shows the real path
	execute ":e " . system("readlink " . $HOME . "/.vim/filemarks/" . a:mark)
endfunction


" ------------------------------------------------------------------------------
" - gitdiffref                                                                 -
" ------------------------------------------------------------------------------
"
" Wrapper for fugitive's Git diff against a stored reference point.  The
" variable that stores the reference contains a capital so that, with
" sessionoptions=globals it will be carried through a session.

nnoremap <space>d :GDiffRef<cr>
command! -nargs=* -complete=customlist,ListGitRefs GDiffRef :call GDiffRef("<args>")
function! ListGitRefs(A,L,P)
	" attempt to simulate vim ins-completion globbing
	let l:filter = substitute(a:A, "*", ".*", "g")
	if (l:filter !~ "*$")
		let l:filter = l:filter . ".*"
	endif
	" get refs
	let refs = []
	for line in split(system("git branch | sed 's/[ *]//g'"))
		if line =~ filter
			let refs += [line]
		endif
	endfor
	for line in split(system("git tag"))
		if line =~ filter
			let refs += [line]
		endif
	endfor
	return refs
endfunction
function! GDiffRef(...)
	if a:0 != 0 && a:1 != ""
		let g:Diffref = a:1
	endif
	execute "Gvdiff " . get(g:, "Diffref", "")
endfunction

" ------------------------------------------------------------------------------
" - whileposchange                                                             -
" ------------------------------------------------------------------------------
"
" Repeats the provided command so long as the cursor changes in any of the
" specified dimensions.

function! WhilePosChange(cmd, bufnum, lnum, col, off)
	let pos = [-1,-1,-1,-1]
	while 1
		execute "normal " . a:cmd
		if a:bufnum && pos[0] != bufnr("%")
			let pos = getpos(".")
			let pos[0] = bufnr("%")
			continue
		endif
		if a:lnum && pos[1] != getpos(".")[1]
			let pos = getpos(".")
			let pos[0] = bufnr("%")
			continue
		endif
		if a:col && pos[2] != getpos(".")[2]
			let pos = getpos(".")
			let pos[0] = bufnr("%")
			continue
		endif
		if a:off && pos[3] != getpos(".")[3]
			let pos = getpos(".")
			let pos[0] = bufnr("%")
			continue
		endif
		break
	endwhile
endfunction

" ------------------------------------------------------------------------------
" - whilepossame                                                               -
" ------------------------------------------------------------------------------
"
" Repeats the provided command until the cursor changes in any of the
" specified dimensions or it doesn't change at all.

function! WhilePosSame(cmd, bufnum, lnum, col, off)
	let pos = getpos(".")
	let pos[0] = bufnr("%")
	while 1
		execute "normal " . a:cmd
		if pos[0] == bufnr("%") && pos[1:] == getpos(".")[1:]
			break
		endif
		if a:bufnum && pos[0] == bufnr("%")
			let pos = getpos(".")
			let pos[0] = bufnr("%")
			continue
		endif
		if a:lnum && pos[1] == getpos(".")[1]
			let pos = getpos(".")
			let pos[0] = bufnr("%")
			continue
		endif
		if a:col && pos[2] == getpos(".")[2]
			let pos = getpos(".")
			let pos[0] = bufnr("%")
			continue
		endif
		if a:off && pos[3] == getpos(".")[3]
			let pos = getpos(".")
			let pos[0] = bufnr("%")
			continue
		endif
		break
	endwhile
endfunction

" ------------------------------------------------------------------------------
" - selectsamelines                                                            -
" ------------------------------------------------------------------------------
"
" Select region with neighboring lines that contain same character in same
" column as cursor
nnoremap <space>v :call SelectSameLines("v")<cr>
nnoremap <space>V :call SelectSameLines("V")<cr>
nnoremap <space><c-v> :call SelectSameLines("\<lt>c-v>")<cr>
function! SelectSameLines(select_cmd)
	let l:start_line = line(".")
	let l:end_line = line(".")
	let l:start_col = col(".")-1
	let l:char = getline(".")[l:start_col]
	" search backwards for start"
	while l:start_line != 1 && getline(l:start_line-1)[l:start_col] == l:char
		let l:start_line -= 1
	endwhile
	while l:start_line != line("$") && getline(l:end_line+1)[l:start_col] == l:char
		let l:end_line += 1
	endwhile
	execute "normal " . start_line . "G" . a:select_cmd . end_line . "G"
endfunction

" ------------------------------------------------------------------------------
" - previewline                                                                -
" ------------------------------------------------------------------------------
" Prints line found via a:cmd at bottom

function! PreviewLine(cmd)
	normal mP
	execute a:cmd
	let previewline=getline(".")
	normal `P
	redraw
	echo previewline
endfunction

" ==============================================================================
" = quick and dirty code                                                       =
" ==============================================================================
"
" Potentially good ideas that need polishing

" ------------------------------------------------------------------------------
" - project management                                                         -
" ------------------------------------------------------------------------------
" The vast majority of the time, my project is tied to a git repository, making
" this unnecessary as I can query git instead.
"
" track settings per project
" probably unnecessary with session management
"function! MarkProjectRoot()
"	" make initial/empty tags file
"	call system('touch ~/.vim/projects/'.substitute(getcwd(),'/','+','g'))
"	call GetProject()
"endfunction
"
"" set current project (if any)
"function! GetProject()
"	let cwd = substitute(getcwd(),'/','+','g')
"	for project in split(system('ls ~/.vim/projects/'))
"		if stridx(cwd,project) == 0
"			let g:project = project
"			execute "set tags+=,~/.vim/projects/".g:project
"			break
"		endif
"	endfor
"endfunction
"call GetProject()

" ------------------------------------------------------------------------------
" - git tags                                                                   -
" ------------------------------------------------------------------------------

"" add current tags from current git project, if any
" looks like fugitive does this automatically
"if system("git rev-parse --show-toplevel") != ""
"	exec "set tags+=" . system("git rev-parse --show-toplevel")[:-2] . "/.git/tags"
"endif

" ------------------------------------------------------------------------------
" - tag select alternative                                                     -
" ------------------------------------------------------------------------------

"" alternative to :tagselect
"command! -nargs=* -complete=custom,ParaTagSelectCompl T :call ParaTagSelect("<args>")
"function! ParaTagSelectCompl(ArgLead, Cmdline, CursorPos)
"	" This is intended for SkyBison which currently does not allow the cursor
"	" to be anywhere but the end of the line.
"
"	let terms = split(a:Cmdline)
"
"	if len(terms) == 1 || (len(terms) == 2 && a:Cmdline[-1:] != " ")
"		let l:d={}
"		execute "silent normal! :tag " . a:ArgLead . "\<c-a>\<c-\>eextend(l:d, {'cmdline':getcmdline()}).cmdline\n"
"		if has_key(l:d, 'cmdline') && l:d['cmdline'] !~ ''
"			return join(split(l:d['cmdline'])[1:],"\n")
"		else
"			return ""
"		endif
"	endif
"	if len(terms) == 2 || (len(terms) == 3 && a:Cmdline[-1:] != " ")
"		let results = []
"		for tag in taglist(terms[1])
"			if count(results, tag['filename']) == 0
"				let results += [tag['filename']]
"			endif
"		endfor
"		return join(results,"\n")
"	endif
"	return ""
"endfunction
"function! ParaTagSelect(Cmdline)
"	let terms = split(a:Cmdline)
"
"	if len(terms) == 2
"		execute "normal :e " . terms[1] . "\<cr>"
"	endif
"	execute "normal :tag " . terms[0] . "\<cr>"
"endfunction

" ------------------------------------------------------------------------------
" - searchsigns                                                                -
" ------------------------------------------------------------------------------
" tying into / and ? is awkward
"
" emphasize lines with search results by populating the signs column
"function! SearchSigns()
"	let l:cursor = getpos(".")
"	sign define search text=// texthl=Error
"	sign unplace *
"	execute "g/". @/ ."/execute 'sign place 1 line=' . line('.') . ' name=search buffer=' . bufnr('%')"
"	call setpos(".", l:cursor)
"endfunction
"augroup signs
"	autocmd CmdwinLeave * if g:lastcmdwin == "/" || g:lastcmdwin == "?" | call feedkeys(":call SearchSigns()","n") | endif
"augroup END


" ------------------------------------------------------------------------------
" - close preview window on insertLeave                                        -
" ------------------------------------------------------------------------------

"autocmd InsertLeave * pclose
"autocmd CmdwinEnter * autocmd! InsertLeave
"autocmd CmdwinLeave * autocmd InsertLeave * pclose
