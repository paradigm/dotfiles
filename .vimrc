" ==============================================================================
" = paradigm's_.vimrc                                                          =
" ==============================================================================
"
" Disclaimer: Note that I have unusual tastes.  Blindly copying lines from this
" or any of my configuration files will not necessarily result in what you will
" consider a sane system.  Please do your due diligence in ensuring you fully
" understand what will happen if you attempt to utilize content from this file,
" either in part or in full.

" Enable syntax highlighting.
syntax on
" set theme
if &t_Co == 256 && filereadable($HOME . "/.themes/current/terminal/256-theme")
	colorscheme currentterm
endif
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
" If run in a terminal, set the terminal title.
set title
" Enable wordwrap
set textwidth=0 wrap linebreak
" Enable unicode characters.  This is needed for the 'listchars' below.
set encoding=utf-8
" Use spellcheck
set spell
" Disable capitalization check in spellcheck.
set spellcapcheck=""
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
" remove comment headers when joining comment lines
set fo+=j
" set what is saved by a :mksession
set sessionoptions=blank,buffers,curdir,folds,help,options,tabpages,winsize,globals,localoptions,tabpages
" Add ~/.vim to the runtimepath in Windows so I can use the same ~/.vim across
" OSs
if has('win32') || has('win64')
	set runtimepath+=~/.vim
endif
" Clear default tags.  Other code later will append tags as needed.
set tags=
" Clear default path.  Other code later will append path items as needed.
set path=
" store swap in ~/.vim/swap
call system("mkdir -p ~/.vim/swap")
set directory=~/.vim/swap
" Use the diffsigns function to calculate diffs (which as a side-effect sets
" sign column)
set diffexpr=diffsigns#run()
" Set thesaurus file location
execute "set thesaurus=" . $HOME . '/.vim/thesaurus'
" Set dictionary file location
" Note that the last field is populated by autoload/def.vim with potential
" non-words.  Ensure "spell" is placed before the def dictionary so it has a
" higher priority.
execute "set dictionary=spell," . $HOME . '/.vim/dictionary'
" If in a git repo, use any tags it may have
if system("git rev-parse --show-toplevel")[0] == '/'
	execute "set tags+=" . system("git rev-parse --show-toplevel")[:-2] . "/.git/tags"
endif


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
" Toggle 'paste'
" This particular mapping is nice due to the ability to paste via
" <insert><s-insert><-sinrt>
set pastetoggle=<insert>

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

" Turn on diffing for current window
nnoremap <c-p>t :diffthis<cr>
" Recalculate diffs
nnoremap <c-p>u :diffupdate<cr><c-l>
" Disable diffs
nnoremap <c-p>x :diffoff<cr>:sign unplace *<cr>
" Yank changes from other diff window
nnoremap <c-p>y do<cr>
" Paste changes into other diff window
nnoremap <c-p>p dp<cr>

" Many of these were either shamelessly stolen from or inspired by
" SearchParty.  See: https://github.com/dahu/SearchParty.  Thanks, bairui.
"
" Having v_* and v_# search for visually selected area.
xnoremap * "*y<Esc>/<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr><cr>
xnoremap # "*y<Esc>?<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr><cr>
" Prepare search based on visually-selected area.  Useful for searching for
" something slightly different from something by the cursor.  For example, if
" on "xnoremap" and looking for "nnoremap"
xnoremap / "*y<Esc>q/i<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr><esc>0
" Prepare substitution based on visually-selected area.
xnoremap ? "*y<Esc>q:i%s/<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr>/

" In pop-up-menu, page down
" In insert mode, do buffer-only completion
inoremap <expr> <c-f> pumvisible() ?
			\ "\<pagedown>" :
			\ "\<c-o>:\<c-u>call custcomplete#run('.')\<cr>\<c-n>"
" In pop-up-menu, page down
" In insert mode, do buffer-only completion
inoremap <expr> <c-b> pumvisible() ?
			\ "\<pageup>" :
			\ "\<c-o>:\<c-u>call custcomplete#run('.')\<cr>\<c-p>"
" Have i_ctrl-<space> act like i_ctrl-x_ctrl-o. Note that ctrl-@ is triggered by
" ctrl-<space> in many terminals.
inoremap <c-@> <c-x><c-o>
" Have i_ctrl-l act like i_ctrl-x_ctrl-l.
inoremap <c-l> <c-x><c-l>
" Jumps to next <++>.
inoremap <expr> <c-j> snippet#jump()
" Goes to next <++>
snoremap <expr> <c-j> snippet#next()

" close the preview window
nnoremap <space>p :pclose\|cclose\|lclose<cr>

"" Create new text objects for pairs of identical characters
"for char in ['$',',','.','/','-','=']
"	exec 'xnoremap i' . char . ' :<C-U>silent!normal!T' . char . 'vt' . char . '<CR>'
"	exec 'onoremap i' . char . ' :normal vi' . char . '<CR>'
"	exec 'xnoremap a' . char . ' :<C-U>silent!normal!F' . char . 'vf' . char . '<CR>'
"	exec 'onoremap a' . char . ' :normal va' . char . '<CR>'
"endfor
" Create a text object for folding regions
" With syntax folding on, this very often does "the right thing"
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

" Compile
nnoremap <space>m        :Make<cr>
" Do a check without compiling
nnoremap <space>l        :Lint<cr>
" Run
nnoremap <space>r        :Run sh<cr>
" Run and put output in a preview window (assumes non-interactive)
nnoremap <space>R        :Run preview<cr>
" Run in an xterm
nnoremap <space><c-r>    :Run xterm<cr>

" Load session
nnoremap <c-k>w          :call session#save()<cr>
" Save session
nnoremap <c-k>l          :call session#load()<cr>

" Fugitive reference against stored reference point
nnoremap <space>D        :GDiffRef<cr>

" All of these will refresh the tags for the open buffers.
"
" Jump to tag, guessing if there are multiple matches
nnoremap <c-]>           :ParaTagsBuffers<cr><c-]>
" Jump to tag, listing options if there are multiple matches
nnoremap g<c-]>           :ParaTagsBuffers<cr>g<c-]>
" Show tag match in preview window
nnoremap <space>P        :ParaTagsBuffers<cr><c-w>}
" Show matching tag line
nnoremap <space><c-p>    :call preview#line("normal! \<lt>c-]>")<cr>

" All of these will perform look-ups as necessary
"
" Complete synonyms
inoremap <c-x><c-t>      <c-o>:call def#populate_thesaurus(expand("<cword>"))<cr><c-x><c-t>
" Preview synonyms
nnoremap g<c-t>          :call def#preview_synonyms(expand("<cword>"))<cr>
" Preview definitions
nnoremap g<c-d>          :call def#preview_definition(expand("<cword>"))<cr>

" Show marks in sign column
nnoremap <space>M        :call signmarks#run()<cr>

" Toggle comments
xnoremap <silent> <c-n>  :call togglecomment#run()<cr>
nnoremap <silent> <c-n>  :call togglecomment#run()<cr>

" Jump to on-screen character
nnoremap        <space>/ :call viewsearch#run()<cr>
onoremap        <space>/ :call viewsearch#run()<cr>
xnoremap <expr> <space>/       viewsearch#expr()

" Vertical jump across contiguous whitespace or non-whitespace.
nnoremap        <space>j :call parajump#run(1)<cr>
onoremap        <space>j :call parajump#run(1)<cr>
xnoremap <expr> <space>j       parajump#expr(1)
nnoremap        <space>k :call parajump#run(-1)<cr>
onoremap        <space>k :call parajump#run(-1)<cr>
xnoremap <expr> <space>k       parajump#expr(-1)

" General SkyBison prompt
nnoremap <space>; :<c-u>call skybison#run()<cr>
" SkyBison prompt for buffers
nnoremap <cr>     :<c-u>call skybison#run("b ", 2)<cr>
" (re)generate local tags then have SkyBison prompt for tags
nnoremap <bs>      :<c-u>ParaTagsBuffers<cr>2:<c-u>call skybison#run("tag ")<cr>
" SkyBison prompt to delete buffer
nnoremap <space>d :<c-u>call skybison#run("bd ")<cr>
" SkyBison prompt to edit a file
nnoremap <space>e  :<c-u>call skybison#run("e ")<cr>
" SkyBison prompt to edit a TagFile
nnoremap <space>f :<c-u>call skybison#run("F ", 2)<cr>
" SkyBison prompt to load a session
nnoremap <space>t :<c-u>call skybison#run("SessionLoad ", 2)<cr>
" SkyBison prompt to jump to a line
nnoremap <space>? :<c-u>call skybison#run("Line ", 2)<cr>
" Switch from normal cmdline to SkyBison
"cnoremap <c-l>     <c-r>=skybison#run("")<cr><cr>
cnoremap <c-l>     <c-\>eskybison#cmdline_switch()<cr><cr>

" Run grammar check on buffer
nnoremap <space>L :LanguageToolCheck<cr>

" Open a scratch window
nnoremap <space>S :Scratch<cr>

" open :help for argument in same window
command! -nargs=1 -complete=help H :help <args> |only
" cd to directory containing current buffer
command! CD :cd %:p:h
" Refresh tags for open buffers
command! ParaTagsBuffers     :call paratags#buffers()
" Refresh tags in non-relative entries in 'path'
command! ParaTagsPath        :call paratags#path()
" Add 'path' tags to 'tags'
command! ParaTagsEnable  :call paratags#path_enable()
" Remove 'path' tags from 'tags'
command! ParaTagsDisable :call paratags#path_disable()
" Simulate a push onto the tag stack
command! FTStackPush :call ftstack#push()
" Simulate a pop from the tag stack
command! FTStackPop  :call ftstack#pop()
" Compile
command! Make :call make#make()
" Do a check without compiling
command! Lint :call make#lint()
" Run
command! -nargs=* -complete=customlist,run#complete Run :call run#run('<args>')
" Grep through open buffers
command! -nargs=* G :call grepbuffers#run(<f-args>)
" Preview synonyms
command! -nargs=1 Thesaurus :call def#preview_synonyms(<f-args>)
" Preview definitions
command! -nargs=1 Dictionary :call def#preview_definition(<f-args>)
" Save session
command! -nargs=1 SessionSave :call session#save(<f-args>)
" Load session
command! -nargs=1 -complete=customlist,session#list SessionLoad :call session#load(<f-args>)
" Switch between header file and c/cpp file
command! SwitchHeader :call switchheader#run()
" Save reference to file
command! -nargs=1 TagFile :call tagfile#set(<f-args>)
" Load TagFile'd file
command! -nargs=1 -complete=customlist,tagfile#complete F :call tagfile#get(<f-args>)
" Fugitive reference against stored reference point
command! -nargs=* -complete=customlist,gitdifref#complete GDiffRef :call gitdifref#run(<f-args>)
" Jump to line
command! -nargs=1 -complete=customlist,line#list Line :call line#run(<f-args>)
" Show quickfix contents next to corresponding lines
command! Qfsplit :call qfsplit#qf_toggle()
" Show location list contents next to corresponding lines
command! Llsplit :call qfsplit#lf_toggle()
" Command to see the element name for character under cursor.  Very helpful
" run to see element name under color
command! SyntaxGroup echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
" Open a scratch window
command! Scratch new|setlocal buftype=nofile bufhidden=delete noswapfile
" Jump to <+jumppoint+>
command! SnippetJump :call snippet#jump()
" Accepts default snippet content
command! SnippetNext :call snippet#next()

" populate signs column after quickfix is populated 
autocmd QuickFixCmdPost * call quickfixsigns#run()
" If a filetype doesn't have it's own omnicompletion, but it does have syntax
" highlighting, use that for omnicompletion
autocmd Filetype *
			\  if &omnifunc == ""
			\|   setlocal omnifunc=syntaxcomplete#Complete
			\| endif
" Set filetype
autocmd BufRead,BufNewFile .vimperatorrc  setfiletype vim
autocmd BufRead,BufNewFile .pentadactylrc setfiletype vim
autocmd BufNewFile,BufRead *.x68          setfiletype asm68k
autocmd BufNewFile,BufRead *.md           setfiletype markdown
autocmd BufNewFile,BufRead *.gv           setfiletype dot
" A normal-mode <cr> mapping breaks some special vim windows, so undo the mapping there
autocmd CmdwinEnter * nnoremap <buffer> <cr> <cr>
autocmd FileType qf nnoremap <buffer> <cr> <cr>
autocmd FileType git nnoremap <buffer> <cr> <cr>
" Have <esc> leave cmdline-window
autocmd CmdwinEnter * nnoremap <buffer> <esc> :q<cr>
" Settings for skybison window
autocmd Filetype skybison inoremap <buffer> <silent> <c-c> <esc>:call skybison#quit()<cr>
autocmd Filetype skybison nnoremap <buffer> <silent> <c-c> :call skybison#quit()<cr>
autocmd Filetype skybison nnoremap <buffer> <silent> <esc> :call skybison#quit()<cr>


" Disable syntax highlighting for diffs - using autoload/diffsigns instead
let g:diffsigns_disablehighlight = 1
" Fold vim functions and augroups.  Cannot put this in ftplugin because it
" won't trigger early enough
let g:vimsyn_folding = 'af'
" Default to LaTeX, not Plain TeX/ConTeXt/etc
let g:tex_flavor='latex'
" Enable fuzzing in skybison
"let g:skybison_fuzz = 2

let g:jedi#use_tabs_not_buffers = 0
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0
let g:jedi#completions_command = "<leader>zzz"
let g:jedi#auto_vim_configuration = 0
let g:jedi#show_call_signatures = 0

" do not automatically pop up completion after a ->, ., or ::
let g:clang_complete_auto = 0
" do not have the clang plugin set mappings, as it makes some disagreeable
" choices.  Do it directly in the .vimrc file.
let g:clang_make_default_keymappings = 0

" Indicate where the LanguageTool jar is located
let g:languagetool_jar='/opt/languagetool/languagetool-commandline.jar'

" disable automatic linting on write
"call manually with: call eclim#lang#UpdateSrcFile('java',1)
let g:EclimJavaValidate = 0
" With JavaSearch/JavaSearchContextalways jump to definition in current window
let g:EclimJavaSearchSingleResult = 'edit'

" Yank to system clipboard
call mapop#load("<space>y", "mapop#system_yank")
" filter through bc
call mapop#load("<space>c", "mapop#filter_bc")
" filter through sage
call mapop#load("<space>C", "mapop#filter_sage")
