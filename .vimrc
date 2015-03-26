" ==============================================================================
" = paradigm's_.vimrc                                                          =
" ==============================================================================

" Disclaimer: Note that I have unusual tastes.  Blindly copying lines from this
" or any of my configuration files will not necessarily result in what you will
" consider a sane system.  Please do your due diligence in ensuring you fully
" understand what will happen if you attempt to utilize content from this file,
" either in part or in full.

" Add ~/.vim to the runtimepath in Windows so I can use the same ~/.vim across
" OSs
if has('win32') || has('win64')
	set runtimepath+=~/.vim
endif

set rtp+=~/.vim/local_bundle/general
set rtp+=~/.vim/local_bundle/theme_currentterm
set rtp+=~/.vim/local_bundle/libs
set rtp+=~/.vim/local_bundle/custom_text_objects
set rtp+=~/.vim/local_bundle/custom_operators
set rtp+=~/.vim/local_bundle/cmdline_window_default
set rtp+=~/.vim/local_bundle/dictionary
set rtp+=~/.vim/local_bundle/wiserange
set rtp+=~/.vim/local_bundle/highlight
set rtp+=~/.vim/local_bundle/digraph_lookup
set rtp+=~/.vim/local_bundle/viewsearch
set rtp+=~/.vim/local_bundle/parajump
set rtp+=~/.vim/local_bundle/diffsigns
set rtp+=~/.vim/local_bundle/signmarks
set rtp+=~/.vim/local_bundle/run
set rtp+=~/.vim/local_bundle/preview
set rtp+=~/.vim/local_bundle/ftstack
set rtp+=~/.vim/local_bundle/skybison
set rtp+=~/.vim/local_bundle/session
set rtp+=~/.vim/local_bundle/snippet
set rtp+=~/.vim/local_bundle/line
set rtp+=~/.vim/local_bundle/switchheader
set rtp+=~/.vim/local_bundle/selectsamelines
set rtp+=~/.vim/local_bundle/grepbuffers
set rtp+=~/.vim/local_bundle/cconerror
set rtp+=~/.vim/local_bundle/paratags
set rtp+=~/.vim/local_bundle/custcomplete
set rtp+=~/.vim/local_bundle/make
set rtp+=~/.vim/local_bundle/qfsplit
set rtp+=~/.vim/local_bundle/quickfixsigns
set rtp+=~/.vim/local_bundle/getheaders
set rtp+=~/.vim/local_bundle/plugin_settings
set rtp+=~/.vim/local_bundle/scratch
set rtp+=~/.vim/local_bundle/handle_directory
set rtp+=~/.vim/local_bundle/yankredir
set rtp+=~/.vim/local_bundle/parainclude
set rtp+=~/.vim/local_bundle/diffdirs
set rtp+=~/.vim/local_bundle/tagcallgraph

set rtp+=~/.vim/remote_bundle/AnsiEsc.vim
set rtp+=~/.vim/remote_bundle/clang_complete
set rtp+=~/.vim/remote_bundle/jedi-vim
set rtp+=~/.vim/remote_bundle/languagetool
set rtp+=~/.vim/remote_bundle/latexbox
set rtp+=~/.vim/remote_bundle/rainbow
set rtp+=~/.vim/remote_bundle/SimpylFold
set rtp+=~/.vim/remote_bundle/tabular
set rtp+=~/.vim/remote_bundle/vim-fugitive
set rtp+=~/.vim/remote_bundle/vim-zsh-completion
set rtp+=~/.vim/remote_bundle/visincr
set rtp+=~/.vim/remote_bundle/wmgraphviz.vim

"set rtp+=~/.vim/remote_bundle/multicursor
"set rtp+=~/.vim/remote_bundle/skybison
"set rtp+=~/.vim/remote_bundle/textobjectify
