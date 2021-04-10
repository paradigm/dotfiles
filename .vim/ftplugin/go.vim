" ==============================================================================
" = go ftplugin                                                                =
" ==============================================================================

setlocal define=\\v^func\\s*(\\[^\\)]*\\))?\\s*\\zs[a-zA-Z_]*

if executable('gopls')
	autocmd User lsp_setup call lsp#register_server({
				\ 'name': 'go-lang',
				\ 'cmd': {server_info->['gopls']},
				\ 'whitelist': ['go'],
				\ })
endif
