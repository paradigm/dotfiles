" ==============================================================================
" = wiserange                                                                  =
" ==============================================================================
"
" Note: accepts but ignores range provided in front of it, as vim only passes
" along lines (making it useless)

command -range -nargs=+ CW call wiserange#char(<f-args>)
command -range -nargs=+ LW call wiserange#line(<f-args>)
command -range -nargs=+ BW call wiserange#block(<f-args>)

if maparg(":", "x") ==# ""
	xnoremap <expr> : ":" . wiserange#prepend_cmdline()
	xnoremap <expr> ! ":" . wiserange#prepend_cmdline() . "!"
elseif maparg(":", "x") =~ "^q:[aiAI]$"
	xnoremap <expr> : "q:a" . wiserange#prepend_cmdline()
	xnoremap <expr> ! "q:a" . wiserange#prepend_cmdline() . "!"
elseif maparg(":", "x") =~ "^:<C-F>[aiAI]"
	xnoremap <expr> : ":<c-f>a" . wiserange#prepend_cmdline()
	xnoremap <expr> ! ":<c-f>a" . wiserange#prepend_cmdline() . "!"
endif
