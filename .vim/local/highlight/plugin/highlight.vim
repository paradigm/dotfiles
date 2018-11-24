let g:highlight_colors = [
			\ ["fg_red",     "red",     "black",   '<c-h>r'],
			\ ["fg_green",   "green",   "black",   '<c-h>g'],
			\ ["fg_blue",    "blue",    "black",   '<c-h>b'],
			\ ["fg_cyan",    "cyan",    "black",   '<c-h>c'],
			\ ["fg_magenta", "magenta", "black",   '<c-h>m'],
			\ ["fg_yellow",  "yellow",  "black",   '<c-h>y'],
			\ ["bg_red",     "black",   "red",     '<c-h>R'],
			\ ["bg_green",   "black",   "green",   '<c-h>G'],
			\ ["bg_blue",    "black",   "blue",    '<c-h>B'],
			\ ["bg_cyan",    "black",   "cyan",    '<c-h>C'],
			\ ["bg_magenta", "black",   "magenta", '<c-h>M'],
			\ ["bg_yellow",  "black",   "yellow",  '<c-h>Y']
			\ ]

command! -nargs=+ -complete=customlist,highlight#add_cmdline_completion HighlightAdd call highlight#add(<q-args>)
command! -nargs=+ -complete=customlist,highlight#remove_cmdline_completion HighlightRemove call highlight#remove(<q-args>)
command! HighlightUndo call highlight#undo()
command! HighlightRemoveAll call highlight#remove_all()
command! HighlightRemoveCursor call highlight#remove_cursor()

nnoremap <c-h>x :HighlightRemoveCursor<cr>
nnoremap <c-h>X :HighlightRemoveAll<cr>
nnoremap <c-h>u :HighlightUndo<cr>
for s:color in g:highlight_colors
	call operators#add(s:color[3], 'Highlight_operator_' . s:color[0])
	execute "function! Highlight_operator_" . s:color[0] . "(type)\ncall highlight#operator(a:type, \"" . s:color[0] . "\")\nendfunction"
endfor
