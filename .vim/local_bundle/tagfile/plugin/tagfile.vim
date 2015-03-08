" Save reference to file
command! -nargs=1 TagFile :call tagfile#set(<f-args>)
" Load TagFile'd file
command! -nargs=1 -complete=customlist,tagfile#complete F :call tagfile#get(<f-args>)
