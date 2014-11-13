" ==============================================================================
" = dot ftplugin                                                               =
" ==============================================================================

" Preview dot output
nnoremap <buffer> <space>o :silent execute "!sxiv -s -V " . expand("%:r").".png &"<cr>

" Set executable to associate with source
let b:runcmd = "xdotool search --name sxiv key r"
let b:runquiet = 1

setlocal makeprg=dot\ -Tpng\ %\ -o\ %:r.png
setlocal errorformat=%EError:\ %f:%l:%m,%WWarning:\ %f:\ %*[^0-9]%l%m
