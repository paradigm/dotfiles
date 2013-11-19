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
" These are general shell settings that don't fit well into any of the
" categories used below.  Order may matter for some of these.

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
" Searches are case-sensitive.
set ignorecase
" Searches are not case sensitive if an uppercase character appears within.
" them.
set smartcase
" Print line numbers on the left.
set number
" if this vim has 'relativenumber', print line number relative to cursor
if exists('&relativenumber')
	set relativenumber
endif
" Always show cursor position in statusline.
set ruler
" default color scheme should assume dark background
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
" Enable unicode characters.  This is needed for 'listchars' below.
set encoding=utf-8
" use spellcheck
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
set timeout ttimeoutlen=10 timeoutlen=500
" Automatically save/load settings for buffer when entering/leaving them.  This
" was disabled as it proved more troublesome than helpful.
"au BufWinLeave * silent! mkview!  " automatically save view on exit
"au BufWinEnter * silent! loadview " automatically load view on load
" Add ~/.vim to the runtimepath in Windows so I can use the same ~/.vim across
" OSs
if has('win32') || has('win64')
	set runtimepath+=~/.vim
endif
" clear default tags
set tags=""
let g:thesaurusfile = $HOME . '/.vim/thesaurus'
execute "set thesaurus+=" . g:thesaurusfile
let g:dictionaryfile = $HOME . '/.vim/dictionary'
" vim's 'dictionary' doesn't support paradigm's dictionary format
" leaving this blank means i_ctrl-x_ctrl-k falls back to spellcheck dictionary
"execute "set dictionary+=" . g:dictionaryfile

" ==============================================================================
" = mappings                                                                   =
" ==============================================================================

" ------------------------------------------------------------------------------
" - general_(mappings)                                                         -
" ------------------------------------------------------------------------------

" Disable <f1>'s default help functionality.
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
nnoremap <space>r :Run<cr>
nnoremap <space>R :RunPreview<cr>
" Faster mapping for spelling correction
nnoremap <space>z 1z=
" Select most recently changed text - particularly useful for pastes
nnoremap <space>v `[v`]
nnoremap <space>V `[V`]
" Provide more comfortable alternative to default window resizing mappings.
nnoremap <c-w><c-h> :vertical resize -10<cr>
nnoremap <c-w><c-l> :vertical resize +10<cr>
nnoremap <c-w><c-j> :resize +10<cr>
nnoremap <c-w><c-k> :resize -10<cr>
" Move by 'display lines' rather than 'logical lines'.
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
xnoremap <space>C :!sage -q 2>/dev/null \| sed '$d' \| sed '$d' \| cut -c7-<cr>
xnoremap <space>L <esc>`<ilatex(<esc>`>a)<esc>gv:!sage -q 2>/dev/null \| sed '$d' \| sed '$d' \| cut -c7-<cr>

" Toggle 'paste'
" This particular mapping is nice because I can paste with
" <insert><s-insert><-sinrt>
set pastetoggle=<insert>
" technically not a map, but I don't want to create a new section for it
" opens :help for argument in same window
command! -nargs=1 -complete=help H :help <args> |
			\ let helpfile = expand("%") |
			\ close |
			\ execute "view ".helpfile
" cd to directory containing current buffer
command! CD :execute ":cd " . expand("%:p:h")

" ------------------------------------------------------------------------------
" - next_previous_(mappings)                                                   -
" ------------------------------------------------------------------------------
" Find next/previous search item which is not visible in the window.
" Note that 'scrolloff' probably breaks this.
nnoremap <space>n L$nzt
nnoremap <space>N H$Nzb
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
" Many of these were either shamelessly stolen from or inspiried by
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
inoremap <expr> <c-f> pumvisible() ? "\<pagedown>" : "\<c-o>:call GenerateTagsForBuffers()\<cr>\<c-o>1\<c-w>}"
" if done without pum, try to open tag
inoremap <expr> <c-b> pumvisible() ? "\<pageup>" : "\<c-o>:pclose\<cr>"
" Have i_ctrl-<space> act like i_ctrl-x_ctrl-o. Note that ctrl-@ is triggered by
" ctrl-<space> in many terminals.
inoremap <c-@> <c-x><c-o>
" Have i_ctrl-l act like i_ctrl-x_ctrl-l.
inoremap <c-l> <c-x><c-l>

" ------------------------------------------------------------------------------
" - comments_(mappings)                                                        -
" ------------------------------------------------------------------------------

" Determine comment character(s) based on filetype.  Vim sets &commentstring
" to the relevant value, but also include '%s' which we want to strip out.
autocmd BufRead * let b:commentcharacters = substitute(&commentstring,"%s","","")
" Comment out selected lines.
xnoremap <silent> <c-n>c :s,^,<c-r>=b:commentcharacters<cr><space>,<cr>:nohlsearch<cr>
" Uncomment out selected lines.
xnoremap <silent> <c-n>u :s,^\V<c-r>=b:commentcharacters<cr><space>,,e<cr>:nohlsearch<cr>
" Align by comment.
nnoremap <silent> <c-n>a :Tabularize /<c-r>=b:commentcharacters<cr><cr>
xnoremap <silent> <c-n>a :Tabularize /<c-r>=b:commentcharacters<cr><cr>
" Create comment heading.
nnoremap <silent> <c-n>h :call CreateCommentHeading(1)<cr>
" Create comment subheading.
nnoremap <silent> <c-n>s :call CreateCommentHeading(2)<cr>
" Create comment subsubheading.
nnoremap <silent> <c-n>S :call CreateCommentHeading(3)<cr>

" ------------------------------------------------------------------------------
" - tags                                                                       -
" ------------------------------------------------------------------------------

" open the preview window
nnoremap <space>p :call GenerateTagsForBuffers()<cr><c-w>}
" close the preview window
nnoremap <space>P :pclose<cr>

" ------------------------------------------------------------------------------
" - plugins_and_functions_(mappings)                                           -
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
nnoremap <bs>      :<c-u>call GenerateTagsForBuffers()<cr>2:<c-u>call SkyBison("tag ")<cr>
" SkyBison prompt editing a file
nnoremap <space>e  :<c-u>call SkyBison("e ")<cr>
" General SkyBison prompt
nnoremap <space>;  :<c-u>call SkyBison("")<cr>
" Startify's session loader
nnoremap <space>t 2:<c-u>call SkyBison("SLoad ")<cr>
" Switch from normal cmdline to SkyBison
cnoremap <c-l>     <c-r>=SkyBison("")<cr><cr>

" ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
" ~ ParaJump_(mappings)                                                        ~
" ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
" Find next item at same indentation level.
nnoremap <space>j :call ParaJump("j",0)<cr>
xnoremap <space>j :call ParaJump("j",1)<cr>
" Find previous item at same indentation level.
nnoremap <space>k :call ParaJump("k",0)<cr>
xnoremap <space>k :call ParaJump("k",1)<cr>

" ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
" ~ LanguageTool_(mappings)                                                    ~
" ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
nnoremap <space>lt :LanguageToolCheck<cr>
nnoremap <space>lc :LanguageToolClear<cr>

" ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
" ~ generate-tags_(mappings)                                                   ~
" ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
nnoremap <c-]> :call GenerateTagsForBuffers()<cr><c-]>

" ------------------------------------------------------------------------------
" - custom_text_objects_(mappings)                                             -
" ------------------------------------------------------------------------------

" Create new text objects for pairs of identical characters
for char in ['$',',','.','/','-','=']
	exec 'xnoremap i' . char . ' :<C-U>silent!normal!T' . char . 'vt' . char . '<CR>'
	exec 'onoremap i' . char . ' :normal vi' . char . '<CR>'
	exec 'xnoremap a' . char . ' :<C-U>silent!normal!F' . char . 'vf' . char . '<CR>'
	exec 'onoremap a' . char . ' :normal va' . char . '<CR>'
endfor
" Create a text object for folding regions
xnoremap if :<C-U>silent!normal![zjV]zk<CR>
onoremap if :normal Vif<CR>
xnoremap af :<C-U>silent!normal![zV]z<CR>
onoremap af :normal Vaf<CR>
" Create a text object for LaTeX environments
xnoremap iv :<C-U>call LatexEnv(1)<CR>
onoremap iv :normal viv<CR>
xnoremap av :<C-U>call LatexEnv(0)<CR>
onoremap av :normal vav<CR>
" Create a text object for the entire buffer
xnoremap i<cr> :<c-u>silent!normal!ggVG<cr>
onoremap i<cr> :normal Vi<c-v><cr><cr>
xnoremap a<cr> :<c-u>silent!normal!ggVG<cr>
onoremap a<cr> :normal Vi<c-v><cr><cr>
"" Create text object based on indentation level
" Replaced with http://www.vim.org/scripts/script.php?script_id=3037
"onoremap <silent>ai :<C-u>cal IndTxtObj(0)<CR>
"onoremap <silent>ii :<C-u>cal IndTxtObj(1)<CR>
"xnoremap <silent>ai :<C-u>cal IndTxtObj(0)<CR><Esc>gv
"xnoremap <silent>ii :<C-u>cal IndTxtObj(1)<CR><Esc>gv


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
" - Language-specific tag settings.
" - get :help for word under cursor
autocmd Filetype vim
			\  inoremap <buffer> <c-x><c-o> <c-x><c-v>
			\| inoremap <buffer> <c-@> <c-x><c-v>
			\| setlocal tags+=~/.vim/tags/vimtags
			\| let g:generate_tags+=["ctags -R -f ~/.vim/tags/vimtags ~/.vim/bundle/"]
			\| let g:generate_tags+=["ctags -R -f ~/.vim/tags/vimtags ~/.vimrc"]
			\| nnoremap <buffer> K :execute "help " . expand("<cword>")<cr>

" ------------------------------------------------------------------------------
" - mail_(filetype-specific)                                                   -
" ------------------------------------------------------------------------------

" Use spellcheck by default when composing an email.
autocmd Filetype mail setlocal spell

" ------------------------------------------------------------------------------
" - python_(filetype-specific)                                                 -
" ------------------------------------------------------------------------------

" - PEP8-friendly tab settings
" - Language-specific tag settings.
" - python syntax-based folding yanked from
"   http://vim.wikia.com/wiki/Syntax_folding_of_Python_files
autocmd Filetype python
			\  setlocal expandtab
			\| setlocal tabstop=4
			\| setlocal shiftwidth=4
			\| setlocal softtabstop=4
			\| setlocal tags+=,~/.vim/tags/pythontags
			\| let g:generate_tags+=["ctags -R -f ~/.vim/tags/pythontags /usr/lib/py* /usr/local/lib/py*"]
			\| setlocal foldtext=substitute(getline(v:foldstart),'\\t','\ \ \ \ ','g')

" ------------------------------------------------------------------------------
" - assembly_(filetype-specific)                                               -
" ------------------------------------------------------------------------------

" Set tabstop to 8 for assembly.
autocmd Filetype asm setlocal tabstop=8

" ------------------------------------------------------------------------------
" - c_(filetype-specific)                                                      -
" ------------------------------------------------------------------------------

" - Language-specific tag settings.
" - open manpage in preview window
autocmd Filetype c
			\  setlocal tags+=,~/.vim/tags/ctags
			\| let g:generate_tags+=["ctags -R -f ~/.vim/tags/ctags /usr/include"]
			\| nnoremap <buffer> K :call PreviewShell("man " . expand("<cword>"))<cr>

" ------------------------------------------------------------------------------
" - c++_(filetype-specific)                                                    -
" ------------------------------------------------------------------------------

" this page intentionally left blank

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
			\| set tags+=,~/.vim/tags/latextags
			\| let g:generate_tags+=["ctags -R -f ~/.vim/tags/latextags /usr/share/texmf-texlive/tex/latex/"]
			\| let g:generate_tags+=["ctags -a -R -f ~/.vim/tags/latextags /usr/share/texmf/tex/latex/"]
			\| let g:generate_tags+=["ctags -a -R -f ~/.vim/tags/latextags ~/texmf/tex/latex/"]
			\| let g:generate_tags+=["ctags -a -R -f ~/.vim/tags/latextags ~/.texmf/tex/latex/"]
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
if filereadable($HOME."/.vim/autoload/pathogen.vim")
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
" - Generate-Tags_(plugins)                                                    -
" ------------------------------------------------------------------------------

let g:generate_tags=[]
execute "set tags+=/dev/shm/.vim-tags-".getpid()
autocmd VimLeave * call delete("/dev/shm/.vim-tags-".getpid())

" ------------------------------------------------------------------------------
" - SkyBison_(plugins)                                                         -
" ------------------------------------------------------------------------------

let g:skybison_fuzz = 2

" ------------------------------------------------------------------------------
" - Startify_(plugins)                                                         -
" ------------------------------------------------------------------------------

" disable start page by default
let g:startify_disable_at_vimenter = 1

" sane defaults
let g:startify_session_savecmds = []
let g:startify_session_savevars = [
			\ "g:startify_session_savevars",
			\ "g:startify_session_savevars"]

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
" this page intentionally left blank

" ------------------------------------------------------------------------------
" - LanguageTool_(plugins)                                                     -
" ------------------------------------------------------------------------------

" Indicate where the LanguageTool jar is located
let g:languagetool_jar='/opt/languagetool/LanguageTool.jar'


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

command! Run :call Run()
function! Run()
	" Move the directory containing the current buffer.  This is helpful in
	" case multiple buffers are open which have different associated
	" ./a.out or equivalent
	execute "cd " . expand("%:p:h")
	" Determine what to run
	if exists("g:runcmd")
		let l:runcmd = g:runcmd
	elseif &ft == "c"
		let l:runpath = "./a.out"
		let l:runcmd = "runpath"
	elseif &ft == "cpp"
		let l:runpath = "./a.out"
		let l:runcmd = "runpath"
	elseif &ft == "python"
		let l:runpath = expand("%:p")
		let l:runcmd = "runpath"
	elseif &ft == "sh"
		let l:runpath = expand("%:p")
		let l:runcmd = "runpath"
	elseif &ft == "tex"
		" reload pdf reader
		let l:runcmd = "!pkill -HUP mupdf"
	endif
	if runcmd == "runpath"
		if !executable(l:runpath)
			redraw!
			echo "Set " . runpath . " as executable? (y/n) "
			if nr2char(getchar()) == "y"
				call system("chmod u+x " . l:runpath)
			endif
		endif
		let l:runcmd = "!" . l:runpath
	endif
	silent! :!clear
	redraw!
	execute l:runcmd
endfunction

command! RunPreview :call RunPreview()
function! RunPreview()
	" Move the directory containing the current buffer.  This is helpful in
	" case multiple buffers are open which have different associated
	" ./a.out or equivalent
	execute "cd " . expand("%:p:h")
	" Determine what to run
	if exists("g:runcmd")
		let l:runcmd = g:runcmd
	elseif &ft == "c"
		let l:runpath = "./a.out"
		let l:runcmd = "runpath"
	elseif &ft == "cpp"
		let l:runpath = "./a.out"
		let l:runcmd = "runpath"
	elseif &ft == "python"
		let l:runpath = expand("%:p")
		let l:runcmd = "runpath"
	elseif &ft == "sh"
		let l:runpath = expand("%:p")
		let l:runcmd = "runpath"
	elseif &ft == "tex"
		" reload pdf reader
		let l:runcmd = "!pkill -HUP mupdf"
	endif
	if runcmd == "runpath"
		if !executable(l:runpath)
			redraw!
			echo "Set " . runpath . " as executable? (y/n) "
			if nr2char(getchar()) == "y"
				call system("chmod u+x " . l:runpath)
			endif
		endif
		call PreviewShell(l:runpath)
		return
	endif
	silent! :!clear
	redraw!
	execute l:runcmd
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
" Jump to the line with the indentation level corresponding to the cursor
" column.

function! ParaJump(direction,visual)
	" sanity check
	if a:direction != 'k' && a:direction != 'j'
		echo "No acceptable direction given"
		return 1
	endif
	" calling functions drops out of visual mode
	" if requested, return to visual mode
	if a:visual == 1
		normal! gv
	endif
	" no particular meaning to being beyond the indent
	if virtcol(".") > indent(line("."))
		exe "normal! ^"
	endif
	" get cursor position to compare to indent levels
	let char_under_cursor = strpart(getline("."),col(".")-1,1)
	let cursor_position = virtcol(".")
	if char_under_cursor == "\t"
		let cursor_position = cursor_position - &tabstop
	elseif char_under_cursor != " "
		let cursor_position = cursor_position - 1
	endif
	" save cursor column to return
	let initcol = string(virtcol("."))
	" set jump mark
	exe "normal! " . line(".") . "G" . initcol . "|"
	" no point in calling this for one line - assume user wants to drop one level
	if (a:direction == 'k' && indent(line(".")-1) == cursor_position) || (a:direction == 'j' && indent(line(".")+1) == cursor_position)
		let cursor_position = cursor_position - &tabstop
	endif
	exe "normal! " . a:direction
	while line(".") != 1 && line(".") != line("$") && (indent(line(".")) != cursor_position || getline(".") =~ "^[\s\t]*$")
		exe "normal! " . a:direction
	endwhile
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
" - generatetagsforbuffers()_(functions)                                       -
" ------------------------------------------------------------------------------
"
" (re)generates tag files from open buffers

function! GenerateTagsForBuffers()
	echo "Generating tags from buffers, may take a few seconds..."
	let l:localtagfile="/dev/shm/.vim-tags-".getpid()
	if filereadable(l:localtagfile)
		call delete(l:localtagfile)
	endif
	for l:buffer_number in range(1,bufnr("$"))
		if buflisted(l:buffer_number)
			let l:buffername = bufname(l:buffer_number)
			if l:buffername[0] != "/"
				let l:buffername = getcwd()."/".l:buffername
			endif
			call system("ctags -a -f ".l:localtagfile." --language-force=".GetCtagsFiletype(getbufvar(l:buffer_number,"&filetype"))." ".l:buffername)
		endif
	endfor
	redraw
	echo "Done generating tags."
endfunction

" ------------------------------------------------------------------------------
" - generatetagsforproject()_(functions)                                      -
" ------------------------------------------------------------------------------
"
" (re)generates tag files for project

function! GenerateTagsForProject()
	echo "Generating project-specific tags, may take a few seconds..."
	let l:projpath = substitute(g:project,'+','/','g')
	call system('ctags -R -f ~/.vim/projects/'.g:project.' '.l:projpath)
	redraw
	echo "Done generating tags."
endfunction

" ------------------------------------------------------------------------------
" - generatetagsforfiletype()_(functions)                                      -
" ------------------------------------------------------------------------------
"
" (re)generates tag files for filetype specific libraries

function! GenerateTagsForFiletype()
	echo "Generating filetype-specific tags, may take a few seconds..."
	for tags_command in g:generate_tags
		call system(tags_command)
	endfor
	redraw
	echo "Done generating tags."
endfunction

" ------------------------------------------------------------------------------
" - getctagsfiletype()_(functions)                                             -
" ------------------------------------------------------------------------------
"
" maps vim's filetype to corresponding ctag's filetype
" used by GenerateTags()

function! GetCtagsFiletype(vimfiletype)
	if a:vimfiletype == "asm"
		return("asm")
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
	silent! execute "!" . a:cmd . " >/dev/shm/.vimshellout-" . getpid()
	execute "pedit! /dev/shm/.vimshellout-" .getpid()
	wincmd P
	setlocal bufhidden=delete
	autocmd VimLeave * call delete("/dev/shm/.vimshellout-".getpid())
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
	let out = "/dev/shm/.vim-thesaurus-out-" . getpid()
	execute "autocmd VimLeave * call delete(\"".out."\")"
	echo "Looking up \"" . a:word . "\"..."
	silent! execute "silent !wget -qO " . out . " http://thesaurus.com/browse/" . a:word
	if !filereadable(out)
		redraw!
		echo "Could not find " . a:word . " at thesaurus.com"
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
	" check if given word is already in local dictionary
	let line = ""
	let found = 0
	if filereadable(g:dictionaryfile)
		for line in readfile(g:dictionaryfile)
			if match(line, "^" . a:word . " ") != -1
				let found = 1
				break
			endif
		endfor
	endif

	" we don't yet have the word, get the dictionary.com page
	if found == 0
		let out = "/dev/shm/.vim-dictionary-out-" . getpid()
		execute "autocmd VimLeave * call delete(\"".out."\")"
		echo "Looking up \"" . a:word . "\"..."
		silent! execute "silent !wget -qO " . out . " http://dictionary.com/browse/" . a:word
		if !filereadable(out)
			redraw!
			echo "Could not find " . a:word . " at dictionary.com"
			call input("ENTER to continue")
			return
		endif

		" parse page for definitions
		" find line with definition on it
		for line in readfile(out)
			let fields = split(line, "\<\\|\>")
			if len(fields) > 2 && fields[2] == 'div class="luna-Ent"'
				break
			endif
		endfor
		let pronounce = substitute(line, '^.*\(\[</span><span class="pron">.*<span class="prondelim">\]\).*$', '\1', '')

		" remove extraneous markup and content
		let line = substitute(line, '<span class="pg">\([^<]\+\)</span>', '\\n\1\\n', 'g')
		for tag in ['<a [^>]*>','</a>', '<div[^>]*>','</div>']
			let line = substitute(line, tag, '', 'g')
		endfor
		echo pronounce
		let pronounce = substitute(pronounce, '<[^>]*>', '', 'g')
		let pronounce = substitute(pronounce, '[ ]\+', '', 'g')
		let line = join(filter(split(line, "\<[^>]*\>"), 'v:val !~ "^[ \t]*$"'))
		let line = line[match(line, "Show IPA")+10:]
		let line = a:word . " " . pronounce . " " . line
	"
		" append synonyms to local dictionary
		if filereadable(g:dictionaryfile)
			let dictionary = readfile(g:dictionaryfile)
		else
			let dictionary = []
		endif
		let dictionary += [line]
		call writefile(dictionary, g:dictionaryfile)
	endif
	
	" show definition in preview window
	let fmt = [join(split(line)[:1])]
	if match(line, ' \d\+\.') == -1
		" only one definition
		let fmt += split(join(split(line)[2:]), '\\n')
	else
		" multiple definitions
		for l in split(join(split(line)[2:]), '\\n')
			for def in split(l, ' \ze\d\+\.')
				for subdef in split(def, ' \ze[a-z]\.')
					if subdef =~ '^[a-z]\.'
						let fmt += [substitute("  " . subdef, '[ \t]\+$', '', '')]
					else
						let fmt += [substitute(subdef, '[ \t]\+$', '', '')]
					endif
				endfor
			endfor
		endfor
	endif
	let out = "/dev/shm/.vim-definition-".getpid()
	execute "autocmd VimLeave * call delete(\"".out."\")"
	call writefile(fmt, out)
	execute "pedit! " . out
	wincmd P
	setlocal nomodifiable
	normal gg
	setlocal bufhidden=delete
	redraw!
endfunction


" ==============================================================================
" = quick and dirty code                                                       =
" ==============================================================================
"
" Potentially good ideas that need polishing

" ------------------------------------------------------------------------------
" - project management                                                         -
" ------------------------------------------------------------------------------
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
" - sign                                                                       -
" ------------------------------------------------------------------------------
"
" various experimentation with sign column

set diffexpr=DiffSigns()
function! DiffSigns()
	sign define added   text=++ texthl=DiffAdd
	sign define deleted text=-- texthl=DiffDelete
	sign define changed text=!! texthl=DiffChange
	sign unplace *
	let opt = ""
	if &diffopt =~ "icase"
		let opt = opt . "-i "
	endif
	if &diffopt =~ "iwhite"
		let opt = opt . "-b "
	endif
	silent execute "!diff -a --binary " . opt . v:fname_in . " " . v:fname_new . " > " . v:fname_out
	let diff = system("cat " . v:fname_out)
"	for bufnr in range(1,bufnr("$"))
"	endfor
	for line in split(diff,"\n")
		if line =~ "^[0-9]"
			let left_side = split(line, "[acd]")[0]
			let right_side = split(line, "[acd]")[1]
			let changetype = split(line, "[0-9,]")[0]
			if left_side =~ ","
				let left_start = split(left_side, ",")[0]
				let left_end = split(left_side, ",")[1]
			else
				let left_start = left_side
				let left_end = left_side
			endif
			if right_side =~ ","
				let right_start = split(right_side, ",")[0]
				let right_end = split(right_side, ",")[1]
			else
				let right_start = right_side
				let right_end = right_side
			endif
			if changetype == "a"
				let left_signtype = "deleted"
				let right_signtype = "added"
			elseif changetype == "d"
				let left_signtype = "added"
				let right_signtype = "deleted"
			elseif changetype == "c"
				let left_signtype = "changed"
				let right_signtype = "changed"
			else
				left_signtype = "???"
				right_signtype = "???"
			endif
			for linenr in range(left_start, left_end)
				if left_signtype != "deleted"
					execute "sign place 1 line=" . linenr . " name=" . left_signtype . " buffer=" . winbufnr(1)
				endif
			endfor
			for linenr in range(right_start, right_end)
				if right_signtype != "deleted"
					execute "sign place 1 line=" . linenr . " name=" . right_signtype . " buffer=" . winbufnr(2)
				endif
			endfor
		endif
	endfor
endfunction

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

" show marks in sign column
"nnoremap <space>M :call SignMarks()<cr>
"function! SignMarks()
"	sign unplace *
"	for mark in ["}","{",")","(","`",".","^",'"',"'",">","<","]","[" ,"9","8","7","6","5","4","3","2","1","0","Z","Y","X","W","V","U","T","S","R","Q","P","O","N","M","L","K","J","I","H","G","F","E","D","C","B","A" ,"z","y","x","w","v","u","t","s","r","q","p","o","n","m","l","k","j","i","h","g","f","e","d","c","b","a"]
"		let char = mark
"		let pos = getpos("'" . char)
"		if pos != [0,0,0,0]
"			if pos[0] != 0
"				let bufnr = pos[0]
"			else
"				let bufnr = bufnr("%")
"			endif
"			execute "sign define mark" . char . " text='" . char . " texthl=NonText"
"			execute "sign place 1 line=" . pos[1] . " name=mark" . char . " buffer=" . bufnr
"		endif
"	endfor
"endfunction


" ------------------------------------------------------------------------------
" - close preview window on insertLeave                                        -
" ------------------------------------------------------------------------------

autocmd InsertLeave * pclose
autocmd CmdwinEnter * autocmd! InsertLeave
autocmd CmdwinLeave * autocmd InsertLeave * pclose
