command! -nargs=* -complete=tag CallerGraph call tagcallgraph#caller(<f-args>)
command! -nargs=* -complete=tag CalleeGraph call tagcallgraph#callee(<f-args>)
