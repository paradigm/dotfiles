" ==============================================================================
" = paradigm's .vimrc                                                          =
" ==============================================================================
"
" Disclaimer: Note that I have unusual tastes.  Blindly copying lines from this
" or any of my configuration files will not necessarily result in what you will
" consider a sane system.  Please do your due diligence in ensuring you fully
" understand what will happen if you attempt to utilize content from this file,
" either in part or in full.

" ==============================================================================
" = general settings                                                           =
" ==============================================================================
"
" These are general shell settings that don't fit well into any of the
" catagories used below.  Order may matter for some of these.

" Disable vi compatibilty restrictions.
set nocompatible
" When creating a new line, set indentation same as previous line.
set autoindent
" Make i_backspace act as it does in most other programs.
set backspace=2
" Folding should be set manually, never automatically.
set foldmethod=manual
" Do not fold anything by default.
set foldlevel=999
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
" Disable modeline.  I know the settings I like; I don't need others telling me
" what to use.  Also, historically, this has been a security vulnerability.
set nomodeline
" Print line numbers on the left.
set number
" Always show cursor position in statusline.
set ruler
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
" Disable capitalization check in spellcheck.
set spellcapcheck=""
" Enable syntax highlighting.
syn on
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
" If available, have pathogen load plugins form ~/.vim/bundle.
if filereadable($HOME."/.vim/autoload/pathogen.vim")
	call pathogen#runtime_append_all_bundles()
	call pathogen#helptags()
endif
" Enable filetype-specific plugins.
filetype plugin on
" Utilize filetype-specific automatic indentation.
filetype indent on

" ==============================================================================
" = mappings                                                                   =
" ==============================================================================

" ------------------------------------------------------------------------------
" - general (mappings)                                                         -
" ------------------------------------------------------------------------------

" Disable <f1>'s default help functionality.
nnoremap <f1> <esc>
inoremap <f1> <esc>
" Clear search highlighting and messages at bottom when redrawing
nnoremap <silent> <c-l> :noh<cr><c-l>
" Faster mapping for saving
nnoremap <space>w :w<cr>
" Faster mapping for closing window / quitting
nnoremap <space>q :q<cr>
" Re-source the .vimrc
nnoremap <space>s :so $MYVIMRC<cr>
" Run :make
nnoremap <space>m :w<cr>:!clear<cr>:silent make %<cr>:cc<cr>
" Execute buffer
nnoremap <space>r :cd %:p:h<cr>:!clear;./%<cr>
" Faster mapping for spelling correction
nnoremap <space>z 1z=
" Select most recently changed text - particularly useful for pastes
nnoremap <space>v '[v']
nnoremap <space>V '[V']
" Provide more comfortable alternative to default window resizing mappings.
nnoremap <c-w><c-h> :vertical res -10<cr>
nnoremap <c-w><c-l> :vertical res +10<cr>
nnoremap <c-w><c-j> :res +10<cr>
nnoremap <c-w><c-k> :res -10<cr>
" Move by 'display lines' rather than 'logical lines'.
nnoremap <silent> j gj
vnoremap <silent> j gj
nnoremap <silent> k gk
vnoremap <silent> k gk
" Ensure 'logical line' movement remains accessible.
nnoremap <silent> gj j
vnoremap <silent> gj j
nnoremap <silent> gk k
vnoremap <silent> gk k
" Toggle 'paste'
set pastetoggle=<insert>

" ------------------------------------------------------------------------------
" - cmdline-window (mappings)                                                  -
" ------------------------------------------------------------------------------

" Swap default ':', '/' and '?' with cmdline-window equivalent.
nnoremap : q:i
vnoremap : q:i
nnoremap / q/i
vnoremap / q/i
nnoremap ? q?i
vnoremap ? q?i
nnoremap q: :
vnoremap q: :
nnoremap q/ /
vnoremap q/ /
nnoremap q? ?
vnoremap q? ?
" Have <esc> leave cmdline-window
au CmdwinEnter * nnoremap <buffer> <ESC> :q<cr>

" ------------------------------------------------------------------------------
" - quickfix list (mappings)                                                   -
" ------------------------------------------------------------------------------

" Move to next quickfix item.
nnoremap +n :cnext<cr>
" Move to previous quickfix item.
nnoremap +p :cpprevious<cr>
" Display current quickfix item.
nnoremap +c :cc<cr>

" ------------------------------------------------------------------------------
" - diff (mappings)                                                            -
" ------------------------------------------------------------------------------

nnoremap <c-p>t :diffthis<cr>
nnoremap <c-p>u :diffupdate<cr>
nnoremap <c-p>x :diffoff<cr>
nnoremap <c-p>y do<cr>
nnoremap <c-p>p dp<cr>

" ------------------------------------------------------------------------------
" - visual-mode searching (mappings)                                           -
" ------------------------------------------------------------------------------
" 
" Many of these were either shamelessly stolen from or inspiried by
" SearchParty.  See: https://github.com/dahu/SearchParty.  Thanks, bairui.

" Having v_* and v_# search for visually selected area.
vnoremap * "*y<Esc>/<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr><cr>
vnoremap # "*y<Esc>?<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr><cr>
" Prepare search based on visually-selected area.  Useful for searching for
" something slightly different from something by the cursor.  For example, if
" on "vnoremap" and looking for "nnoremap"
vnoremap / "*y<Esc>q/i<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr><esc>0
" Prepare substitution based on visually-selected area.
vnoremap & "*y<Esc>q:i%s/<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr>/

" ------------------------------------------------------------------------------
" - insert-mode completion (mappings)                                          -
" ------------------------------------------------------------------------------

" Allow ctrl-f/ctrl-b to page through pop-up menu.
inoremap <expr> <c-f> pumvisible() ? "\<pagedown>" : "\<c-f>"
inoremap <expr> <c-b> pumvisible() ? "\<pageup>" : "\<c-b>"
" Have i_ctrl-<space> act like i_ctrl-x_ctrl-o. Note that ctrl-@ is triggered by
" ctrl-<space> in many terminals.
inoremap <c-@> <c-x><c-o>
" Have i_ctrl-l act like i_ctrl-x_ctrl-l.
inoremap <c-l> <c-x><c-l>

" ------------------------------------------------------------------------------
" - comments (mappings)                                                        -
" ------------------------------------------------------------------------------

" Determine comment character(s) based on filetype.  Vim sets &commentstring
" to the relevant value, but also include '%s' which we want to strip out.
au Bufread * let b:commentcharacters = substitute(&commentstring,"%s","","")
" Comment out selected lines.
vnoremap <silent> <c-n>c :s!^!<c-r>=b:commentcharacters<cr><space>!<cr>:noh<cr>
" Uncomment out selected lines.
vnoremap <silent> <c-n>u :s!^\V<c-r>=b:commentcharacters<cr><space>!!e<cr>:noh<cr>
" Align by comment.
nnoremap <silent> <c-n>a :Tabularize /<c-r>=b:commentcharacters<cr><cr>
vnoremap <silent> <c-n>a :Tabularize /<c-r>=b:commentcharacters<cr><cr>
" Create comment heading.
nnoremap <silent> <c-n>h :call CreateCommentHeading(1)<cr>
" Create comment subheading.
nnoremap <silent> <c-n>s :call CreateCommentHeading(2)<cr>
" Create comment subsubheading.
nnoremap <silent> <c-n>S :call CreateCommentHeading(3)<cr>

" ------------------------------------------------------------------------------
" - plugins and functions (mappings)                                           -
" ------------------------------------------------------------------------------

" Use ParaMenu to manage buffers.
nnoremap <cr> :ParaBuffers<cr>
" Do not use ParaBuffers in the cmdline-window.
au CmdwinEnter * nnoremap <cr> a<cr>
au CmdwinLeave * nnoremap <cr> :call ParaBuffers()<cr>
" Use ParaMenu to manage tags.
nnoremap <bs> :ParaTags<cr>
" Use ParaMenu to manage the Quickfix list.
nnoremap <space>x :ParaQuickFix<cr>
" Use ParaIncr to increment/decriment after visual selection.
vnoremap <space>i :call ParaIncr(1,"","")<cr>
vnoremap <space>I :call ParaIncr(1," ","")<cr>
vnoremap <space>d :call ParaIncr(-1,"","")<cr>
vnoremap <space>D :call ParaIncr(-1," ","")<cr>
" Guess the range to select for ParaIncr.
nnoremap <space>i :<c-u>call ParaIncrVisSelect(1,"","")<cr>
nnoremap <space>I :<c-u>call ParaIncrVisSelect(1," ","")<cr>
nnoremap <space>d :<c-u>call ParaIncrVisSelect(-1,"","")<cr>
nnoremap <space>D :<c-u>call ParaIncrVisSelect(-1," ","")<cr>
" Find next/previous search item which is not visible in the window.
" Note that 'scrolloff' probably breaks this.
nnoremap <space>n L$nzt
nnoremap <space>N H$Nzb
" Find next item at same indentation level.
nnoremap <space>j :call ParaJump("j",0)<cr>
vnoremap <space>j :call ParaJump("j",1)<cr>
" Find previous item at same indentation level.
nnoremap <space>k :call ParaJump("k",0)<cr>
vnoremap <space>k :call ParaJump("k",1)<cr>
" faster mapping for easymotion's 'f'.
nmap <space>f \f
nmap <space>F \F
vmap <space>f \f
vmap <space>F \F
" Fast access to LanguageTool
nnoremap <space>lt :LanguageToolCheck<cr>
nnoremap <space>lc :LanguageToolClear<cr>
" ParaSurround - new surroundings
vnoremap s <esc>:call ParaSurround(0)<cr>
" ParaSurround - use previous surroundings
vnoremap S <esc>:call ParaSurround(1)<cr>
" ParaSurround - use previous region size and surroundings
nnoremap <space>S :call ParaSurround(2)<cr>
" (re)generate tags
nnoremap <space>g :call GenerateTagsForBuffers()<cr>
nnoremap <space>G :call GenerateTagsForFiletype()<cr>
let g:generate_tags=[]

" ------------------------------------------------------------------------------
" - custom text objects (mappings)                                             -
" ------------------------------------------------------------------------------

" Create new text objects for pairs of identical characters
for char in ['$',',','.','/','-','=']
	exec 'vnoremap i' . char . ' :<C-U>silent!normal!T' . char . 'vt' . char . '<CR>'
	exec 'onoremap i' . char . ' :normal vi' . char . '<CR>'
	exec 'vnoremap a' . char . ' :<C-U>silent!normal!F' . char . 'vf' . char . '<CR>'
	exec 'onoremap a' . char . ' :normal va' . char . '<CR>'
endfor
" Create a text object for folding regions
vnoremap if :<C-U>silent!normal![zjV]zk<CR>
onoremap if :normal Vif<CR>
vnoremap af :<C-U>silent!normal![zV]z<CR>
onoremap af :normal Vaf<CR>
" Create a text object for LaTeX environments
vnoremap iv :<C-U>call LatexEnv(1)<CR>
onoremap iv :normal viv<CR>
vnoremap av :<C-U>call LatexEnv(0)<CR>
onoremap av :normal vav<CR>
" Create a text object for the entire buffer
vnoremap i<cr> :<c-u>silent!normal!ggVG<cr>
onoremap i<cr> :normal Vi<c-v><cr><cr>
vnoremap a<cr> :<c-u>silent!normal!ggVG<cr>
onoremap a<cr> :normal Vi<c-v><cr><cr>
" Create text object based on indentation level
" Replaced with http://www.vim.org/scripts/script.php?script_id=3037
"onoremap <silent>ai :<C-u>cal IndTxtObj(0)<CR>
"onoremap <silent>ii :<C-u>cal IndTxtObj(1)<CR>
"vnoremap <silent>ai :<C-u>cal IndTxtObj(0)<CR><Esc>gv
"vnoremap <silent>ii :<C-u>cal IndTxtObj(1)<CR><Esc>gv

" ------------------------------------------------------------------------------
" - git (mappings)                                                             -
" ------------------------------------------------------------------------------

" Commit
nnoremap <space>gc :w<cr>:!git commit -a<cr>
" Push
nnoremap <space>gp :!git push origin master<cr>

" ==============================================================================
" = theme                                                                      =
" ==============================================================================

" Command to see the element name for character under cursor.  Very helpful
" run to see element name under color
command! SyntaxGroup echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')

" Set theme if 256 colors are available.

if &t_Co == 256

" ------------------------------------------------------------------------------
" - color definitions (theme)                                                  -
" ------------------------------------------------------------------------------
"
" Define colors that will be used repeatedly.

" Green-based:
"	let nfg = 10
"	let nbg = 0
"	let hfg = 120
"	let hbg = 0
"	let ifg = 28
"	let ibg = 0
"	let efg = 9
"	let ebg = 0
"	let m1fg = 82
"	let m1bg = 0
"	let m2fg = 47
"	let m2bg = 0
"	let m3fg = 70
"	let m3bg = 0
"	let m4fg = 35
"	let m4bg = 0

" Cyan-based:
"	let nfg = 37
"	let nbg = 0
"	let hfg = 51
"	let hbg = 0
"	let ifg = 23
"	let ibg = 0
"	let efg = 196
"	let ebg = 0
"	let m1fg = 35
"	let m1bg = 0
"	let m2fg = 25
"	let m2bg = 0
"	let m3fg = 36
"	let m3bg = 0
"	let m4fg = 31
"	let m4bg = 0

"" Blue-based:
"	let nfg = 19
"	let nbg = 0
"	let hfg = 21
"	let hbg = 0
"	let ifg = 17
"	let ibg = 0
"	let efg = 196
"	let ebg = 0
"	let m1fg = 25
"	let m1bg = 0
"	let m2fg = 55
"	let m2bg = 0
"	let m3fg = 31
"	let m3bg = 0
"	let m4fg = 91
"	let m4bg = 0

"" White-based:
"	let nfg  = 231 " white
"	let nbg  = 0   " black
"	let hfg  = 0   " black
"	let hbg  = 231 " white
"	let ifg  = 240 " about 30% white
"	let ibg  = 0   " black
"	let efg  = 196 " red
"	let ebg  = 0   " black
"	let m1fg = 147 " blue-white
"	let m1bg = 0   " black
"	let m2fg = 157 " green-white
"	let m2bg = 0   " black
"	let m3fg = 159 " slight cyan
"	let m3bg = 0   " black
"	let m4fg = 217 " slight red
"	let m4bg = 0   " black

" Grayscale:
	let nfg  = 231 " white
	let nbg  = 0   " black
	let hfg  = 0   " black
	let hbg  = 231 " white
	let ifg  = 240 " about 30% white
	let ibg  = 0   " black
	let efg  = 196 " red
	let ebg  = 0   " black
	let m1fg = 250 " gray 74
	let m1bg = 0   " black
	let m2fg = 248 " gray 66
	let m2bg = 0   " black
	let m3fg = 244 " gray 50
	let m3bg = 0   " black
	let m4fg = 257 " gray 82
	let m4bg = 0   " black


" ------------------------------------------------------------------------------
" - general syntax (theme)                                                     -
" ------------------------------------------------------------------------------

	execute "highlight Comment    cterm   = NONE"
	execute "highlight Comment    ctermfg = " . ifg
	execute "highlight Comment    ctermbg = " . ibg
	execute "highlight Constant   cterm   = NONE"
	execute "highlight Constant   ctermfg = " . m3fg
	execute "highlight Constant   ctermbg = " . m3bg
	execute "highlight Error      cterm   = NONE"
	execute "highlight Error      ctermfg = " . m2fg
	execute "highlight Error      ctermbg = " . m2bg
	execute "highlight Identifier cterm   = NONE"
	execute "highlight Identifier ctermfg = " . m3fg
	execute "highlight Identifier ctermbg = " . m3bg
	execute "highlight PreProc    cterm   = NONE"
	execute "highlight PreProc    ctermfg = " . m2fg
	execute "highlight PreProc    ctermbg = " . m2bg
	execute "highlight Special    cterm   = NONE"
	execute "highlight Special    ctermfg = " . m1fg
	execute "highlight Special    ctermbg = " . m1bg
	execute "highlight Statement  cterm   = NONE"
	execute "highlight Statement  ctermfg = " . m1fg
	execute "highlight Statement  ctermbg = " . m1bg
	execute "highlight Type       cterm   = NONE"
	execute "highlight Type       ctermfg = " . m4fg
	execute "highlight Type       ctermbg = " . m4bg
	" spelling
	highlight clear SpellBad
	highlight SpellBad cterm=underline

" ------------------------------------------------------------------------------
" - vim chrome (theme)                                                         -
" ------------------------------------------------------------------------------

	execute "highlight LineNr       cterm   = None"
	execute "highlight LineNr       ctermfg = " . ifg
	execute "highlight LineNr       ctermbg = " . ibg
	execute "highlight SpecialKey   cterm   = NONE"
	execute "highlight SpecialKey   ctermfg = " . ifg
	execute "highlight SpecialKey   ctermbg = " . ibg
	execute "highlight Folded       cterm   = NONE"
	execute "highlight Folded       ctermfg = " . ifg
	execute "highlight Folded       ctermbg = " . ibg
	execute "highlight MatchParen   cterm   = NONE"
	execute "highlight MatchParen   ctermfg = " . hfg
	execute "highlight MatchParen   ctermbg = " . hbg
	execute "highlight NonText      cterm   = NONE"
	execute "highlight NonText      ctermfg = " . ifg
	execute "highlight NonText      ctermbg = " . ibg
	execute "highlight Search       cterm   = NONE"
	execute "highlight Search       ctermfg = " . hfg
	execute "highlight Search       ctermbg = " . hbg
	execute "highlight ModeMsg      cterm   = NONE"
	execute "highlight ModeMsg      ctermfg = " . ifg
	execute "highlight ModeMsg      ctermbg = " . ibg
	execute "highlight MoreMsg      cterm   = NONE"
	execute "highlight MoreMsg      ctermfg = " . ifg
	execute "highlight MoreMsg      ctermbg = " . ibg
	execute "highlight Pmenu        cterm   = NONE"
	execute "highlight Pmenu        ctermfg = " . nfg
	execute "highlight Pmenu        ctermbg = " . nbg
	execute "highlight PmenuSel     cterm   = NONE"
	execute "highlight PmenuSel     ctermfg = " . hfg
	execute "highlight PmenuSel     ctermbg = " . hbg
	execute "highlight PmenuSbar    cterm   = NONE"
	execute "highlight PmenuSbar    ctermfg = " . efg
	execute "highlight PmenuSbar    ctermbg = " . ebg
	execute "highlight StatusLine   cterm   = NONE"
	execute "highlight StatusLine   ctermfg = " . ifg
	execute "highlight StatusLine   ctermbg = " . ibg
	execute "highlight StatusLineNC cterm   = NONE"
	execute "highlight StatusLineNC ctermfg = " . ifg
	execute "highlight StatusLineNC ctermbg = " . ibg
	execute "highlight TabLine      cterm   = NONE"
	execute "highlight TabLine      ctermfg = " . ifg
	execute "highlight TabLine      ctermbg = " . ibg
	execute "highlight TabLineFill  cterm   = NONE"
	execute "highlight TabLineFill  ctermbg = " . nfg
	execute "highlight TabLineSel   cterm   = NONE"
	execute "highlight TabLineSel   ctermfg = " . hfg
	execute "highlight TabLineSel   ctermbg = " . hbg
	execute "highlight Title        cterm   = NONE"
	execute "highlight Title        ctermfg = " . ifg
	execute "highlight Title        ctermbg = " . ibg
	execute "highlight VertSplit    cterm   = NONE"
	execute "highlight VertSplit    ctermfg = " . ifg
	execute "highlight VertSplit    ctermbg = " . ibg
	execute "highlight Visual       cterm   = NONE"
	execute "highlight Visual       ctermfg = " . nbg
	execute "highlight Visual       ctermbg = " . nfg
endif


" ==============================================================================
" = filetype-specific settings                                                 =
" ==============================================================================

" ------------------------------------------------------------------------------
" - viml (filetype-specific)                                                   -
" ------------------------------------------------------------------------------

" VimL has its own omnicompletion mapping by default, separate from the normal
" one.  Set the normal omnicompletion mapping to cover the special VimL
" completion.
au Filetype vim inoremap <buffer> <c-x><c-o> <c-x><c-v>
" Note that c-@ is triggered by c-space.
au Filetype vim inoremap <buffer> <c-@> <c-x><c-v>

" ------------------------------------------------------------------------------
" - mail (filetype-specific)                                                   -
" ------------------------------------------------------------------------------

" Use spellcheck by default when composing an email.
au Filetype mail set spell

" ------------------------------------------------------------------------------
" - python (filetype-specific)                                                 -
" ------------------------------------------------------------------------------
"
" The python community strongly favors using spaces for indentation rather
" than tabs.  However, I like tabs (and 'list').  When opening a .py file,
" convert the space-indentation to tabs, and when saving, convert the tabs
" back to spaces.

" Convert indentation from spaces to tabs when opening a file.
au Filetype python retab!
" Convert indentation from tabs to spaces when wring a file to disk, then
" immediately back when saving is done.
au Filetype python au BufWritePre * :set expandtab
au Filetype python au BufWritePre * :retab!
au Filetype python au BufWritePost * :set noexpandtab!
au Filetype python au BufWritePost * :retab!
" 'Compile' with pep8.
au Filetype python set makeprg=pep8
au Filetype python set errorformat=%f:%l:%c:%m
" Execute.
au Filetype python nnoremap <buffer> <space>r :cd %:p:h<cr>:!python %<cr>

" ------------------------------------------------------------------------------
" - assembly (filetype-specific)                                               -
" ------------------------------------------------------------------------------

" Set tabstop to 8 for assembly.
au Filetype asm set tabstop=8

" ------------------------------------------------------------------------------
" - c (filetype-specific)                                                      -
" ------------------------------------------------------------------------------

" Set compiler.
au Filetype c set makeprg=gcc
" Execute result.
au Filetype c nnoremap <buffer> <space>r :cd %:p:h<cr>:!clear;./a.out<cr>
" include c tags
au Filetype c set tags+=,~/.vim/tags/ctags
" regenerate tags
au Filetype c let g:generate_tags+=["ctags -R -f ~/.vim/tags/ctags /usr/include"]

" ------------------------------------------------------------------------------
" - c++ (filetype-specific)                                                    -
" ------------------------------------------------------------------------------

" Set compiler.
au Filetype cpp set makeprg=g++
" Execute.
au Filetype cpp nnoremap <buffer> <space>r :cd %:p:h<cr>:!clear;./a.out<cr>

" ------------------------------------------------------------------------------
" - tex (filetype-specific)                                                    -
" ------------------------------------------------------------------------------

" ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
" ~ general options (tex)                                                      ~
" ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
" Default to LaTeX, not Plain TeX/ConTeXt/etc
let g:tex_flavor='latex'
" Enable spell check
au Filetype tex set spell
" Parse TeX output for errors and use them in the quickfix menu
au Filetype tex set makeprg=lualatex\ \-file\-line\-error\ \-interaction=nonstopmode\ $*\\\|\ awk\ '/^\\(.*.tex$/{sub(/^./,\"\",$0);X=$0}\ /^!/{sub(/^./,\"\",$0);print\ X\":1:\"$0}\ /tex:[0-9]+:\ /{A=$0;MORE=2}\ (MORE==2\ &&\ /^l.[0-9]/){sub(/^l.[0-9]+[\ \\t]+/,\"\",$0);B=$0;MORE=1}\ (MORE==1\ &&\ /^[\ ]+/){sub(/^[\ \\t]+/,\"\",$0);print\ A\":\ \"B\"·\"$0;MORE=0}'
au Filetype tex set errorformat=%f:%l:\ %m
" ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
" ~ lualatex highlighting (tex)                                                ~
" ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
" LuaTeX embeds Lua code into TeX documents.  The following code tells vim to
" use Lua highlighting in the relevant sections within a TeX document.
au Filetype tex if exists("b:current_syntax") && b:current_syntax == "tex"
au Filetype tex unlet b:current_syntax
au Filetype tex syntax include @TEX syntax/tex.vim
au Filetype tex unlet b:current_syntax
au Filetype tex syntax include @LUA syntax/lua.vim
au Filetype tex syntax match texComment '%.*$' containedin=luatex contains=@texCommentGroup
au Filetype tex syntax region luatex matchgroup=Snip start='\\directlua{' end='}' containedin=@TEX contains=@LUA contains=@texComment
au Filetype tex highlight link Snip SpecialComment
au Filetype tex let b:current_syntax="luatex"
au Filetype tex endif
" ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
" ~ custom mappings (tex)                                                      ~
" ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
" Compile TeX document and, if successful, reload pdf reader
au Filetype tex nnoremap <buffer> <space>m :w<cr>:!clear<cr>:silent make %<cr>:if(len(getqflist())==0)<cr>execute '!pkill -HUP mupdf'<cr>endif<cr><cr>:cc<cr>
" Reload PDF reader
au Filetype tex nnoremap <buffer> <space>r :silent !pkill -HUP mupdf<cr><C-L>
" Utilize vim-latexsuite style jumping
au Filetype tex inoremap <buffer> <c-j> <ESC>:call LatexJump()<cr>
" Various LaTeX mappings to save keystrokes in common situations
au Filetype tex inoremap <buffer> ;; <ESC>o\item<space>
au Filetype tex inoremap <buffer> ;' <ESC>o\item[]\hfill<cr><TAB><++><ESC>k0f[a
au Filetype tex inoremap <buffer> (( \left(\right)<++><ESC>10hi
au Filetype tex inoremap <buffer> [[ \left[\right]<++><ESC>10hi
au Filetype tex inoremap <buffer> {{ \left\{\right\}<++><ESC>11hi
au Filetype tex inoremap <buffer> __ _{}<++><ESC>4hi
au Filetype tex inoremap <buffer> ^^ ^{}<++><ESC>4hi
au Filetype tex inoremap <buffer> == &=
au Filetype tex inoremap <buffer> ;new \documentclass{}<cr>\begin{document}<cr><++><cr>\end{document}<ESC>3kf{a
au Filetype tex inoremap <buffer> ;use \usepackage{}<ESC>i
au Filetype tex inoremap <buffer> ;f \frac{}{<++>}<++><ESC>10hi
au Filetype tex inoremap <buffer> ;td \todo[]{}<esc>i
au Filetype tex inoremap <buffer> ;sk \sketch[]{}<esc>i
au Filetype tex inoremap <buffer> ;mi \begin{minipage}{.9\columnwidth}<cr>\end{minipage}<ESC>ko
au Filetype tex inoremap <buffer> ;al \begin{align*}<cr>\end{align*}<ESC>ko
au Filetype tex inoremap <buffer> ;mb \begin{bmatrix}<cr>\end{bmatrix}<ESC>ko
au Filetype tex inoremap <buffer> ;mp \begin{pmatrix}<cr>\end{pmatrix}<ESC>ko
au Filetype tex inoremap <buffer> ;li \begin{itemize}<cr>\end{itemize}<ESC>ko\item<space>
au Filetype tex inoremap <buffer> ;le \begin{enumerate}<cr>\end{enumerate}<ESC>ko\item<space>
au Filetype tex inoremap <buffer> ;ld \begin{description}<cr>\end{description}<ESC>ko\item[]\hfill<cr><tab><++><ESC>k0f[a
au Filetype tex inoremap <buffer> ;ca \begin{cases}<cr>\end{cases}<ESC>ko
au Filetype tex inoremap <buffer> ;tb \begin{tabular}{llllllllll}<cr>\end{tabular}<ESC>ko\toprule<cr>\midrule<cr>\bottomrule<ESC>kko
au Filetype tex inoremap <buffer> ;ll \begin{lstlisting}<cr>\end{lstlisting}<ESC>ko
au Filetype tex inoremap <buffer> ;df \begin{definition}[]<cr>\end{definition}<ESC>ko<++><esc>k0f[a
au Filetype tex inoremap <buffer> ;xp \begin{example}[]<cr>\end{example}<ESC>ko<++><esc>k0f[a
au Filetype tex inoremap <buffer> ;sl \begin{solution}<cr>\end{solution}<ESC>ko<++><esc>k0f[a
" Tabularize mappingts for common TeX alignment situations
au Filetype tex nnoremap <buffer> <space>& :Tab /&<cr>
au Filetype tex vnoremap <buffer> <space>& :Tab /&<cr>
au Filetype tex nnoremap <buffer> <space>\ :Tab /\\\\<cr>
au Filetype tex vnoremap <buffer> <space>\ :Tab /\\\\<cr>
au Filetype tex nnoremap <buffer> <space>tl :Tab /&=\?/r0l0r0l0r0l0<cr>gv:Tab /\\\\<cr>
au Filetype tex vnoremap <buffer> <space>tl :Tab /&=\?/r0l0r0l0r0l0<cr>gv:Tab /\\\\<cr>
" Tabularize Automatically
" Disabled as more troublesome than helpful
"au Filetype tex inoremap & &<Esc>:let columnnum=<c-r>=strlen(substitute(getline('.')[0:col('.')],'[^&]','','g'))<cr><cr>:Tabularize /&<cr>:normal 0<cr>:normal <c-r>=columnnum<cr>f&<cr>a
" ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
" ~ tags (tex)                                                                 ~
" ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
" include latex tags
au Filetype tex set tags+=,~/.vim/tags/latextags
" regenerate tags
au Filetype tex let g:generate_tags+=["ctags -R -f ~/.vim/tags/latextags /usr/share/texmf-texlive/tex/latex/"]
au Filetype tex let g:generate_tags+=["ctags -a -R -f ~/.vim/tags/latextags ~/.texmf/tex/latex/"]

" ------------------------------------------------------------------------------
" - other (filetype-specific)                                                  -
" ------------------------------------------------------------------------------
"
" If a filetype doesn't have it's own omnicompletion, but it does have syntax
" highlighting, use that for omnicompletion

if has("autocmd") && exists("+omnifunc")
	autocmd Filetype *
				\ if &omnifunc == "" |
				\         setlocal omnifunc=syntaxcomplete#Complete |
				\ endif
endif

" ==============================================================================
" = plugin settings                                                            =
" ==============================================================================

" ------------------------------------------------------------------------------
" - paramenu (plugins)                                                         -
" ------------------------------------------------------------------------------
" Set which keys are used for selection
let g:ParaMenuSelectionKeys = ["0","1","2","3","4","5","6","7","8","9"]
" Set which keys are used for miscellanous functionality
let g:ParaMenuSPecialKeys = ["\<esc>","\<cr>","\<tab>"]
" Set direction of selection keys
let g:ParaMenuSelectionDirection = 0
" Prefer case sensitive matching
let g:ParaMenuFilterCaseInsensitive = 0
" Disable regex
let g:ParaMenuFilterRegex = 0
" Disable fuzzing
let g:ParaMenuFilterFuzz = 0
" Use ramdisk for temporary directory
let g:ParaTagsTempDir = "/dev/shm/"
" Automatically generate tags when ParaTags is run
let g:ParaTagsAutoCreate = 1

" ------------------------------------------------------------------------------
" - easymotion (plugins)                                                       -
" ------------------------------------------------------------------------------
"
" Use \ as prefix for easymotion commands
let g:EasyMotion_leader_key = '\'
" Do not prioritize closer items.  I primarily like easymotion for long jumps;
" prioritizing close things is actively harmful for my use-case.
let g:EasyMotion_grouping = 2
" Set colorscheme
highlight EasyMotionTarget  cterm=NONE ctermfg=Cyan      ctermbg=Black
highlight EasyMotionShade   cterm=NONE ctermfg=DarkBlue  ctermbg=Black

" ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
" ~ languagetool (plugins)                                                     ~
" ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 

" Indicate where the LanguageTool jar is located
let g:languagetool_jar='/opt/languagetool/LanguageTool.jar'

" ------------------------------------------------------------------------------
" - GenerateTagsForBuffers                                                     -
" ------------------------------------------------------------------------------

execute "set tags+=/dev/shm/.vim-tags-".getpid()
au VimLeave * call delete("/dev/shm/.vim-tags-".getpid())


" ==============================================================================
" = custom functions                                                           =
" ==============================================================================

" ------------------------------------------------------------------------------
" - paraincr() (functions)                                                     -
" ------------------------------------------------------------------------------
"
" Increments/decriments column of numbers.

function! ParaIncr(direction,bufferingchar,bufferingside)
	" get register data to restore later
	let initregister = @"
	" get data may need later
	if virtcol("'<") < virtcol("'>")
		let leftcol = virtcol("'<")
		let rightcol = virtcol("'>")
	else
		let leftcol = virtcol("'>")
		let rightcol = virtcol("'<")
	endif
	if line("'<") < line("'>")
		let topline = line("'<")
		let botline = line("'>")
	else
		let topline = line("'>")
		let botline = line("'<")
	endif
	" first line, set everything up
	if line(".") == topline
		" find starting value, being careful with tabs
		if (rightcol+1)<virtcol("$")
			exe "normal! " . leftcol . "|y" . string(rightcol+1) . "|"
		else
			exe "normal! " . leftcol . "|y$"
		end
		let b:ParaIncrValue = str2nr(@")
		" get delta from v:count and direction
		let b:ParaIncrDelta =  v:count1 * a:direction
		" simulation to find width
		let b:ParaIncrWidth = strlen(string(b:ParaIncrValue))
		for line in range(topline,botline)
			let b:ParaIncrValue = b:ParaIncrValue + b:ParaIncrDelta
			if strlen(string(b:ParaIncrValue)) > b:ParaIncrWidth
				let b:ParaIncrWidth = strlen(string(b:ParaIncrValue))
			endif
		endfor
		" reset starting value after simulation
		let b:ParaIncrValue = str2nr(@")
	else
		" not first line, increment by delta
		let b:ParaIncrValue = b:ParaIncrValue + b:ParaIncrDelta
	endif
	" prepare new value to be substituted over old value
	if a:bufferingside == "r" || a:bufferingside == "R" || a:bufferingside == "right"
		" put buffering on right
		let newvalue = string(b:ParaIncrValue) . repeat(a:bufferingchar,b:ParaIncrWidth-strlen(string(b:ParaIncrValue)))
	else
		" put buffering on left
		let newvalue = repeat(a:bufferingchar,b:ParaIncrWidth-strlen(string(b:ParaIncrValue))) . string(b:ParaIncrValue)
	endif
	" subtstitute in new value
	exe "normal! " . string(leftcol) . "|" . string(rightcol-leftcol+1) . "s" . newvalue . "\<esc>"
	" reset register information
	let @" = initregister
endfunction

" ------------------------------------------------------------------------------
" - paraincrvisselect() (functions)                                            -
" ------------------------------------------------------------------------------
"
" Selects a block for ParaIncr().  To use, simply call ParaIncrVisSelect() with
" the cursor over a number (in a column of the same number)

function! ParaIncrVisSelect(direction,bufferingchar,bufferingside)
	" get register data to restore later
	let initregister = @"
	" get starting cursor position
	let initvcol = virtcol(".")
	let initcol = col(".")
	let initline = line(".")
	let initchar = strpart(getline("."),col(".")-1,1)
	" quick sanity check
	if initchar !~ "[0-9-]"
		echo "Not on a number, aborting ParaIncrVisSelect"
		return 1
	endif
	" find all four borders
	" search for leftcol
	if initchar == "-"
		" already on leftmost column - can't have '-' in the middle of a number
		let leftvcol = initvcol
	else
		" search left for first non-number character
		if search("[^0-9-]","b",line(".")) != line(".")
			let leftvcol = 1
		else
			call search("[0-9-]","",line(".")) " compensate for overshooting
			let leftvcol = virtcol(".")
		endif
	endif
	call cursor(initline,initcol) " reset cursor position
	" search for rightcolumn
	if search("[^0-9]","",line(".")) != line(".")
		let rightvcol = virtcol("$") - 1
	else
		call search("[0-9]","b",line(".")) " compensate for overshooting
		let rightvcol = virtcol(".")
	endif
	if (rightvcol+1) < virtcol("$")
		exe "normal! " . leftvcol . "|y" . string(rightvcol+1) . "|"
	else
		exe "normal! " . leftvcol . "|y$"
	end
	" store value for reference later
	let goalstring = @"
	" search upwards for first line
	let topline = initline
	while topline != 1 && goalstring == @"
		" decriment topline and move cursor up
		let topline = topline - 1
		normal! k
		" check if goalstring still exists in this line
		if (rightvcol+1) < virtcol("$")
			exe "normal! " . leftvcol . "|y" . string(rightvcol+1) . "|"
		else
			exe "normal! " . leftvcol . "|y$"
		endif
	endwhile
	" check if while loop overshot by one
	if goalstring != @"
		let topline = topline + 1
	endif
	" search downwards for last line
	let @" = goalstring
	let botline = initline
	while botline != line("$") && goalstring == @"
		" increment botline and move cursor down
		let botline = botline + 1
		normal! j
		if (rightvcol+1) < virtcol("$")
			exe "normal! " . leftvcol . "|y" . string(rightvcol+1) . "|"
		else
			exe "normal! " . leftvcol . "|y$"
		endif
	endwhile
	" check if while loop overshot by one
	if goalstring != @"
		let botline = botline - 1
	endif
	" call ParaIncr() with found range
	exe "normal! " . botline . "G" . rightvcol . "|\<c-v>" . topline . "G" . leftvcol . "|:call ParaIncr(" . string(a:direction) . ", " . string(a:bufferingchar) . ", " . string(a:bufferingside) . ")\<cr>"
	" reset register information
	let @" = initregister
endfunction

" ------------------------------------------------------------------------------
" - latexjump() (functions)                                                    -
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
" - latexenv() (functions)                                                     -
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
" - parajump() (functions)                                                     -
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
		"echo "^"
		"getchar()
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
" - createcommentheading() (functions)                                         -
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
" - parasurround() (functions)                                                 -
" ------------------------------------------------------------------------------
"
" Surround visually-selected areas

function! ParaSurround(previous)
	if a:previous == 0 || !exists('g:ParaSurroundLeft') || !exists('g:ParaSurroundRight')
		let g:ParaSurroundLeft = input("Left: ")
		let g:ParaSurroundRight = input("Right: ")
	endif
	if a:previous == 2
		if !exists('g:ParaSurroundLength')
			let g:ParaSurroundLength = 1
		endif
		execute "normal v".g:ParaSurroundLength."l\<esc>"
	endif
	let g:ParaSurroundLength = col("'>") - col("'<")
	execute "normal `>a".g:ParaSurroundRight
	execute "normal `<i".g:ParaSurroundLeft
	execute "normal `>".strlen(g:ParaSurroundLeft)."l".strlen(g:ParaSurroundRight)."l"
endfunction

" ------------------------------------------------------------------------------
" - generatetagsforbuffers() (functions)                                       -
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
" - generatetagsforfiletype                                                    -
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
" - getctagsfiletype() (functions)                                             -
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
	elseif a:vimfiletype == "vim"
		return("vim")
	elseif a:vimfiletype == "yacc"
		return("yacc")
	else
		return("")
	endif
endfunction
