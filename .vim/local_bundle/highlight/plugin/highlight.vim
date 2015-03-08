" ==============================================================================
" = highlight                                                                  =
" ==============================================================================

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

for color in g:highlight_colors
	let name = color[0]
	let fg = color[1]
	let bg = color[2]
	let map = color[3]
	execute 'highlight Highlight' . name . ' ctermfg=' . fg . ' ctermbg= ' . bg
	execute "function! highlight#add_" . name . "(type)\ncall highlight#range(a:type, \"Highlight" . name . "\")\nendfunction"
	execute 'call custom_operators#load("' . map . '", "highlight#add_' . name . '")'
endfor

nnoremap <c-h>x :call highlight#remove_under_cursor()<cr>
nnoremap <c-h>X :call highlight#remove_all()<cr>
nnoremap <c-h>u :call highlight#undo()<cr>

command! -nargs=* -complete=customlist,highlight#complete_add Highlight :call highlight#add(<f-args>)
command! -nargs=* -complete=customlist,highlight#complete_remove RemoveHighlight :call highlight#remove(<f-args>)
