" ==============================================================================
" = paradigm's_.vimrc                                                          =
" ==============================================================================

" Disclaimer: Note that I have unusual tastes.  Blindly copying lines from
" this or any of my configuration files will not necessarily result in what
" you will consider a sane system.  Please do your due diligence in ensuring
" you fully understand what will happen if you attempt to utilize any content
" here, either in part or in full.

" Set 'nocompatible' defaults.  This is useful when using -u to avoid also
" requiring -N.  This changes quite a few settings and should be placed very
" early to avoid stepping on other settings.
set nocompatible

" explicitly set 'runtimepath' - no default
set runtimepath=
set runtimepath+=~/.vim/

set runtimepath+=~/.vim/local/settings
set runtimepath+=~/.vim/local/support
set runtimepath+=~/.vim/local/commands
set runtimepath+=~/.vim/local/cmdline_window
set runtimepath+=~/.vim/local/mappings
set runtimepath+=~/.vim/local/autocmds
set runtimepath+=~/.vim/local/syntax_omnicomplete
set runtimepath+=~/.vim/local/syntax_settings
set runtimepath+=~/.vim/local/next_previous
set runtimepath+=~/.vim/local/plugin_settings
set runtimepath+=~/.vim/local/set_filetype
set runtimepath+=~/.vim/local/theme_currentterm
set runtimepath+=~/.vim/local/text_objects
set runtimepath+=~/.vim/local/operators
set runtimepath+=~/.vim/local/motions
set runtimepath+=~/.vim/local/registers
set runtimepath+=~/.vim/local/ins_completion
set runtimepath+=~/.vim/local/wiserange
set runtimepath+=~/.vim/local/preview
set runtimepath+=~/.vim/local/dictionary
set runtimepath+=~/.vim/local/digraph
set runtimepath+=~/.vim/local/highlight
set runtimepath+=~/.vim/local/snippet
set runtimepath+=~/.vim/local/grep
set runtimepath+=~/.vim/local/sign_marks
set runtimepath+=~/.vim/local/diffdirs
set runtimepath+=~/.vim/local/diffsigns
set runtimepath+=~/.vim/local/make
set runtimepath+=~/.vim/local/run
set runtimepath+=~/.vim/local/quickfixsigns
set runtimepath+=~/.vim/local/switchheader
set runtimepath+=~/.vim/local/parainclude
set runtimepath+=~/.vim/local/get_headers
set runtimepath+=~/.vim/local/skybison
set runtimepath+=~/.vim/local/handle_directory
set runtimepath+=~/.vim/local/paratags
set runtimepath+=~/.vim/local/session
set runtimepath+=~/.vim/local/line
set runtimepath+=~/.vim/local/edit
set runtimepath+=~/.vim/local/tagcallgraph
set runtimepath+=~/.vim/local/general_increment
set runtimepath+=~/.vim/local/abook
set runtimepath+=~/.vim/local/chore
set runtimepath+=~/.vim/local/languagetool/

set runtimepath+=~/.vim/remote/AnsiEsc.vim/
set runtimepath+=~/.vim/remote/tabular
set runtimepath+=~/.vim/remote/vim-fugitive/
set runtimepath+=~/.vim/remote/vim-ledger/
set runtimepath+=~/.vim/remote/vim-lsp/
set runtimepath+=~/.vim/remote/vim-toml/
set runtimepath+=~/.vim/remote/vim-zsh-completion/

" scripts bundled with vim
set runtimepath+=$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after
