let g:paratags_groups = [
			\ {'name': 'buffers',   'keys': '<c-p>b', 'auto': 1, 'refresh_func': 'paratags#buffers_refresh',   'tagfile_func': 'paratags#buffers_tagfile'},
			\ {'name': 'include',   'keys': '<c-p>i', 'auto': 1, 'refresh_func': 'paratags#include_refresh',   'tagfile_func': 'paratags#include_tagfile'},
			\ {'name': 'git',       'keys': '<c-p>g', 'auto': 0, 'refresh_func': 'paratags#git_refresh',       'tagfile_func': 'paratags#git_tagfile'},
			\ {'name': 'library',   'keys': '<c-p>l', 'auto': 0, 'refresh_func': 'paratags#library_refresh',   'tagfile_func': 'paratags#library_tagfile'},
			\ {'name': 'favorites', 'keys': '<c-p>f', 'auto': 0, 'refresh_func': 'paratags#favorites_refresh', 'tagfile_func': 'paratags#favorites_tagfile'},
			\ ]

for group in g:paratags_groups
	execute 'nnoremap ' . group['keys'] . ' :<c-u>PTGroup ' . group['name'] . '<cr>'
endfor

command! -bar -nargs=1 -complete=customlist,paratags#cmdline_completion PTGroup :call paratags#group(<q-args>)
command! -bar PTAuto :call paratags#auto()
command! -bar PTRefresh :call paratags#refresh()
command! -bar PTStatus :call paratags#status()
command! -bar PTToggleAuto :call paratags#toggleauto()
command! -bar -nargs=* PTFavoriteAdd :call paratags#favorites_add(<f-args>)

nnoremap <silent> <c-p>s   :<c-u>PTStatus<cr>
nnoremap <silent> <c-p>t   :<c-u>PTToggleAuto<cr>
nnoremap <silent> <c-p>r   :<c-u>PTRefresh<cr>
nnoremap          <c-p>F   :<c-u>PTFavoriteAdd<cr>

nnoremap <silent> <c-]>    :<c-u>PTAuto<cr><c-]>
nnoremap <silent> g<c-]>   :<c-u>PTAuto<cr>g<c-]>
nnoremap <silent> <space>P :<c-u>PTAuto<cr><c-w>}
