" disable netrw
let g:loaded_netrwPlugin = 1
let g:loaded_netrw = 1

" jedi does a lot of things automatically by default; disable them.
let g:jedi#use_tabs_not_buffers = 0
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0
let g:jedi#completions_command = "<leader>zzz"
let g:jedi#auto_vim_configuration = 0
let g:jedi#show_call_signatures = 0

" Do not enable rainbow parenthesis by default, but do ensure it is accessible
" via :RainbowToggle
let g:rainbow_active = 0

" do not automatically pop up completion after a ->, ., or ::
let g:clang_complete_auto = 0
" do not have the clang plugin set mappings, as it makes some disagreeable
" choices.  Do it directly in the .vimrc file.
let g:clang_make_default_keymappings = 0
" libclang location for clang_complete to utilize
let g:clang_library_path = "/usr/lib/llvm-6.0/lib/"

" disable automatic linting on write
"call manually with: call eclim#lang#UpdateSrcFile('java',1)
let g:EclimJavaValidate = 0
" With JavaSearch/JavaSearchContextalways jump to definition in current window
let g:EclimJavaSearchSingleResult = 'edit'

let g:ale_sign_error = 'EE'
let g:ale_sign_warning = 'WW'

" rust completion
let g:racer_cmd = 'racer'
let $RUST_SRC_PATH=$HOME . "/.vim/remote/rust/src/"

let g:languagetool_jar = "/bedrock/strata/arch/usr/share/java/languagetool/languagetool-commandline.jar"
