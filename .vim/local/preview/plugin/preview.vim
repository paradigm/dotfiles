command! -bang -nargs=+ PreviewShell call preview#shell(<q-args>, "<bang>" == "!")
command! -bang -nargs=+ PreviewMan call preview#man(<q-args>, "<bang>" == "!")
command! -bang -nargs=+ PreviewJump call preview#jump(<q-args>, "<bang>" == "!")
command! -bang -nargs=+ PreviewCmd call preview#cmd(<q-args>, "<bang>" == "!")
