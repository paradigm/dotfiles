" Grep through open buffers
command! -nargs=* G :call grepbuffers#run(<f-args>)
