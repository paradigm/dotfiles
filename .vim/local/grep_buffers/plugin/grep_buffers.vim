command! -nargs=* G :call grep_buffers#qflist(<q-args>)
command! -nargs=* L :call grep_buffers#loclist(<q-args>)
