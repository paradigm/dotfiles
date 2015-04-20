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
" Close buffer and remove from buffer list
nnoremap <space>Q :split\|bnext\|wincmd w\|bd<cr>
nnoremap <space><c-q> :split\|bnext\|wincmd w\|bd!<cr>
" Re-source the .vimrc
nnoremap <space>s :so $MYVIMRC \| runtime! plugin/**/*.vim<cr>
" Faster mapping for spelling correction
nnoremap <space>z 1z=
" close the preview window
nnoremap <space>p :pclose\|cclose\|lclose<cr>
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

" Turn on diffing for current window
nnoremap <c-q>t :diffthis<cr>
" Recalculate diffs
nnoremap <c-q>u :diffupdate<cr><c-l>
" Disable diffs
nnoremap <c-q>x :diffoff<cr>:sign unplace *<cr>
" Yank changes from other diff window
nnoremap <c-q>y do<cr>
" Paste changes into other diff window
nnoremap <c-q>p dp<cr>

" In pop-up-menu, page down
" In insert mode, do buffer-only completion
inoremap <expr> <c-f> pumvisible() ?
			\ "\<pagedown>" :
			\ "\<c-f>"
" In pop-up-menu, page down
" In insert mode, do buffer-only completion
inoremap <expr> <c-b> pumvisible() ?
			\ "\<pageup>" :
			\ "\<c-b>"
" Have i_ctrl-<space> act like i_ctrl-x_ctrl-o. Note that ctrl-@ is triggered by
" ctrl-<space> in many terminals.
inoremap <c-@> <c-x><c-o>
" Have i_ctrl-l act like i_ctrl-x_ctrl-l.
inoremap <c-l> <c-x><c-l>

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

nnoremap <space>S :Scratch<cr>
