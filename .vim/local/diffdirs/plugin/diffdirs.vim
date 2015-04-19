command! -nargs=+ DiffDirsRun :silent call diffdirs#run(<f-args>)
command! DiffDirsUpdate :silent call diffdirs#update()
