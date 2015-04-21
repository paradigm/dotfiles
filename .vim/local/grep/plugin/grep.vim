command! -bang -nargs=+ -complete=dir Agrep call grep#settings(
			\ 'ag --vimgrep $*',
			\ '%f:%l:%c:%m',
			\ "<bang>",
			\ '',
			\ <f-args>)

command! -bang -nargs=+ -complete=dir Algrep call grep#settings(
			\ 'ag --vimgrep $*',
			\ '%f:%l:%c:%m',
			\ "<bang>",
			\ 'l',
			\ <f-args>)

command! -bang -nargs=+ -complete=dir Ggrep call grep#settings(
			\ 'git grep -n --no-color $*',
			\ '%f:%l:%m',
			\ "<bang>",
			\ '',
			\ <f-args>)

command! -bang -nargs=+ -complete=dir Glgrep call grep#settings(
			\ 'git grep -n --no-color $*',
			\ '%f:%l:%m',
			\ "<bang>",
			\ 'l',
			\ <f-args>)

command! -nargs=+ Gbuf :call grep#buffers(<q-args>, '')
command! -nargs=+ LGbuf :call grep#buffers(<q-args>, 'l')
