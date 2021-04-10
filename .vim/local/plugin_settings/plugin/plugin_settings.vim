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

let g:languagetool_jar = "/bedrock/strata/arch/usr/share/java/languagetool/languagetool-commandline.jar"

" vim-lsp
function! s:on_lsp_buffer_enabled() abort
	setlocal omnifunc=lsp#complete
	setlocal signcolumn=yes
	if exists('+tagfunc')
		setlocal tagfunc=lsp#tagfunc
	endif

	let g:lsp_diagnostics_highlights_enabled = 0
	let g:lsp_document_highlight_enabled = 0
	let g:lsp_diagnostics_echo_movement = 1
	let g:lsp_document_code_action_signs_enabled = 0

	highlight link LspErrorText Normal
	highlight link LspWarningText Comment
	highlight link LspInformationText Comment
	highlight link LspHintText Comment

	nmap <buffer> <c-]> <plug>(lsp-definition)
	nmap <buffer> gd <plug>(lsp-definition)
	nmap <buffer> g<c-]> <plug>(lsp-declaration)
	nmap <buffer> <backspace> <plug>(lsp-document-symbol-search)
	nmap <buffer> g<backspace> <plug>(lsp-workspace-symbol-search)
	"" doesn't work with e.g. rust-analyzer, detect where it does before setting it
	" nmap <buffer> gq <plug>(lsp-document-range-format)
	nmap <buffer> <space>l <plug>(lsp-document-diagnostics)
	nmap <buffer> <space>L <plug>(lsp-preview-diagnostic)
	nmap <buffer> ]q <plug>(lsp-next-diagnostic-nowrap)
	nmap <buffer> [q <plug>(lsp-previous-diagnostic-nowrap)
	nmap <buffer> <c-w>} <plug>(lsp-peek-definition)
	nmap <buffer> <space>P <plug>(lsp-peek-definition)
	nmap <buffer> gr <plug>(lsp-references)
	nmap <buffer> gi <plug>(lsp-implementation)
	nmap <buffer> K <plug>(lsp-hover)
	" nmap <buffer> <space>rn <plug>(lsp-rename) " just call :LspRename
	" nmap <buffer> <space>p <plug>(lsp-preview-close)
endfunction
augroup lsp_install
	au!
	" call s:on_lsp_buffer_enabled only for languages that has the server registered.
	autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
