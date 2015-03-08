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
