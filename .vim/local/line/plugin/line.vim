" Jump to line
command! -nargs=1 -complete=customlist,line#list Line :call line#run(<f-args>)
