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

" Indicate where the LanguageTool jar is located
let g:languagetool_jar='/opt/languagetool/languagetool-commandline.jar'

" disable automatic linting on write
"call manually with: call eclim#lang#UpdateSrcFile('java',1)
let g:EclimJavaValidate = 0
" With JavaSearch/JavaSearchContextalways jump to definition in current window
let g:EclimJavaSearchSingleResult = 'edit'

" Run grammar check on buffer
nnoremap <space>L :LanguageToolCheck<cr>
