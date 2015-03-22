" ==============================================================================
" = glob2regex                                                                 =
" ==============================================================================
" Converts a glob-style string to a regex-style string

function! glob2regex#conv(glob)
	let regex = '\V' . escape(a:glob,'/\')
	let regex = substitute(regex, '\V*', '\\.\\*', 'g')
	return regex
endfunction
