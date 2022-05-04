" ==============================================================================
" = go ftplugin                                                                =
" ==============================================================================

setlocal define=\\v^func\\s*(\\[^\\)]*\\))?\\s*\\zs[a-zA-Z_]*


if executable('gopls')
	let lsp_format_on_save=1
	autocmd User lsp_setup call lsp#register_server({
				\ 'name': 'go-lang',
				\ 'cmd': {server_info->['gopls']},
				\ 'whitelist': ['go'],
				\ })
endif
