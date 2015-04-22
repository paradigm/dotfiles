let g:edit_max = 20
command! -bang -nargs=* -bar -complete=file E call edit#run("<bang>", <f-args>)
