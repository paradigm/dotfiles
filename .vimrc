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
set timeout ttimeoutlen=10 timeoutlen=500
" set what is saved by a :mksession
set sessionoptions=blank,buffers,curdir,folds,help,options,tabpages,winsize,globals,localoptions,tabpages
" Add ~/.vim to the runtimepath in Windows so I can use the same ~/.vim across
" OSs
if has('win32') || has('win64')
	set runtimepath+=~/.vim
endif
" Clear default tags.  Other code later will append tags as needed.
set tags=""
" Use the diffsigns function to calculate diffs (which as a side-effect sets
" sign column)
let g:diffsigns_disablehighlight = 1
set diffexpr=diffsigns#run()
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
xnoremap <space>y "+ygv"*y
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
" next/previous/first/last diff change
"nnoremap ]c ]c " this is already default
"nnoremap [c [c " this is already default
nnoremap [C :call whilepos#change("[c",1,1,1,1)<cr>
nnoremap ]C :call whilepos#change("]c",1,1,1,1)<cr>
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
" next/previous/first/last/prevbuf/nextbuf quickfix item
nnoremap ]q :cnext<cr>
nnoremap [q :cprevious<cr>
nnoremap [Q :cfirst<cr>
nnoremap ]Q :clast<cr>
nnoremap [<c-q> :call whilepos#same(":cprev\<lt>cr>",1,0,0,0)<cr>
nnoremap ]<c-q> :call whilepos#same(":cnext\<lt>cr>",1,0,0,0)<cr>
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
" next/previous file from jump history
nnoremap [f :call whilepos#same("\<lt>c-o>",1,0,0,0)<cr>
" <esc> is used to indicate the end of the whitespace separation after a
" :normal in the function call
nnoremap ]f :call whilepos#same("\<lt>esc>\<lt>c-i>",1,0,0,0)<cr>

" ------------------------------------------------------------------------------
" - cmdline-window_(mappings)                                                  -
" ------------------------------------------------------------------------------

" Swap default ':', '/' and '?' with cmdline-window equivalent.
nnoremap : q:a
xnoremap : q:a
nnoremap / q/a
xnoremap / q/a
nnoremap ? q?a
xnoremap ? q?a
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
inoremap <expr> <c-f> pumvisible() ? "\<pagedown>" : "\<c-o>:ParaTagsBuffers\<cr>\<c-o>1\<c-w>}"
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
" Create a text object for lines which share character in col(".")
xnoremap il :<c-u>silent! call selectsamelines#run("\<lt>c-v>")<cr>
onoremap il :normal vil<cr>
xnoremap al :<c-u>silent! call selectsamelines#run("V")<cr>
onoremap al :normal val<cr>
"" Create text object based on indentation level
" Replaced with http://www.vim.org/scripts/script.php?script_id=3037

" ------------------------------------------------------------------------------
" - autoload_(mappings)                                                        -
" ------------------------------------------------------------------------------
"
" These all call functions defined in ~/.vim/autoload or a command which does
" so.  See the respective autoload file for details.

nnoremap <space>m        :Make<cr>
nnoremap <space>r        :Run sh<cr>
nnoremap <space>R        :Run preview<cr>
nnoremap <space><c-r>    :Run xterm<cr>
nnoremap <c-k>w          :call session#save()<cr>
nnoremap <c-k>l          :call session#load()<cr>
nnoremap <space>D        :GDiffRef<cr>
nnoremap <c-]>           :ParaTagsBuffers<cr><c-]>
nnoremap <space>P        :ParaTagsBuffers<cr><c-w>}
nnoremap <space><c-p>    :ParaTagsBuffers<cr>:call preview#line("normal <c-]>")<cr>
nnoremap <expr> <space>j parajump#run('j')
xnoremap <expr> <space>j parajump#run('j')
nnoremap <expr> <space>k parajump#run('k')
xnoremap <expr> <space>k parajump#run('k')
inoremap <c-x><c-t>      <c-o>:call def#thesaurus(expand("<cword>"))<cr><c-x><c-t>
nnoremap g<c-t>          :call def#previewthesaurus(expand("<cword>"))<cr>
nnoremap g<c-d>          :call def#dictionary(expand("<cword>"))<cr>
nnoremap <space>M        :call signmarks#run()<cr>
xnoremap <silent> <c-n>  :call togglecomment#run()<cr>
nnoremap <silent> <c-n>  :call togglecomment#run()<cr>


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
nnoremap <bs>      :<c-u>ParaTagsBuffers<cr>2:<c-u>call SkyBison("tag ")<cr>
" SkyBison prompt to delete buffer
nnoremap <space>d 2:<c-u>call SkyBison("bd ")<cr>
" SkyBison prompt to edit a file
nnoremap <space>e  :<c-u>call SkyBison("e ")<cr>
" SkyBison prompt to edit a TagFile
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

" ==============================================================================
" = commands                                                                   =
" ==============================================================================

" ------------------------------------------------------------------------------
" - general_(commands)                                                         -
" ------------------------------------------------------------------------------

" open :help for argument in same window
command! -nargs=1 -complete=help H :help <args> |
			\ let helpfile = expand("%") |
			\ close |
			\ execute "view ".helpfile

" cd to directory containing current buffer
command! CD :cd %:p:h

" Commands to call autoload functions.
" See ~/.vim/autoload/ contents for details
command! ParaTagsBuffers :call paratags#buffers()
command! FTStackPush :call ftstack#push()
command! FTStackPop  :call ftstack#pop()

" ------------------------------------------------------------------------------
" - autoload_(commands)                                                        -
" ------------------------------------------------------------------------------
"
" These all call functions defined in ~/.vim/autoload.  See the respective
" autoload file for details.

command! Make :call make#run()
command! -nargs=* -complete=customlist,run#complete Run :call run#run("<args>")
command! -nargs=* G :call grepbuffers#run("<args>")
command! -nargs=1 Thesaurus :call def#previewthesaurus("<args>")
command! -nargs=1 Dictionary :call def#dictionary("<args>")
command! -nargs=1 SessionSave :call session#save("<args>")
command! -nargs=1 -complete=customlist,session#list SessionLoad :call session#load("<args>")
command! SwitchHeader :call switchheader#run()
command! -nargs=1 TagFile :call tagfile#set("<args>")
command! -nargs=1 -complete=customlist,tagfile#complete F :call tagfile#get("<args>")
command! -nargs=* -complete=customlist,gitdefref#complete GDiffRef :call gitdefref#run("<args>")
command! Qfsplit :call qfsplit#qf_toggle()
command! Llsplit :call qfsplit#lf_toggle()

" ==============================================================================
" = autocmds                                                                   =
" ==============================================================================

" ------------------------------------------------------------------------------
" - general_(autocmds)                                                         -
" ------------------------------------------------------------------------------

" populate signs column after quickfix is populated 
autocmd QuickFixCmdPost * call quickfixsigns#run()

" If a filetype doesn't have it's own omnicompletion, but it does have syntax
" highlighting, use that for omnicompletion

autocmd Filetype *
			\  if &omnifunc == ""
			\|   setlocal omnifunc=syntaxcomplete#Complete
			\| endif

" ------------------------------------------------------------------------------
" - fix_filetype_(autocmds)                                                    -
" ------------------------------------------------------------------------------

autocmd BufRead,BufNewFile .vimperatorrc  setfiletype vim
autocmd BufRead,BufNewFile .pentadactylrc setfiletype vim
autocmd BufNewFile,BufRead *.x68          setfiletype asm68k
autocmd BufNewFile,BufRead *.md           setfiletype markdown
autocmd BufNewFile,BufRead *.gv           setfiletype dot
" Default to LaTeX, not Plain TeX/ConTeXt/etc
let g:tex_flavor='latex'

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
