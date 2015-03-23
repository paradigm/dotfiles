" Enable syntax highlighting.
syntax on
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
" Searches are case-insensitive...
set ignorecase
" ...except searches are not case-insensitive if an uppercase character
" appears within them.  So just all-lowercase searches are case-insensitive.
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
" Remove comment headers when joining comment lines
set formatoptions+=j
" Save almost everything when executing a :mksession
set sessionoptions=blank,buffers,curdir,folds,help,options,tabpages,winsize,globals,localoptions,tabpages
" store swap in ~/.vim/swap
if !isdirectory($HOME . "/.vim/swap")
	call mkdir($HOME . "/.vim/swap", "p", 0700)
endif
set directory=~/.vim/swap
" store persistent undo in ~/.vim/undo
set undofile
if !isdirectory($HOME . "/.vim/undo")
	call mkdir($HOME . "/.vim/undo", "p", 0700)
endif
set undodir=~/.vim/undo
" Clear default path
set path=
" Clear default tags
set tags=
