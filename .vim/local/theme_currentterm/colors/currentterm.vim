" 'currentterm' Vim color scheme
" Maintainer:	Daniel "paradigm" Thau <paradigm@bedrocklinux.org>
" Last Change:	2013-11-16

" currentterm
" This theme parses files from $HOME/.themes/current/terminal/<t_Co>-theme and
" uses those to set the colors.  The idea is multiple programs will utilize
" this file to ensure a unified theme across the system.

set background=dark
highlight clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "currentterm"

let loaded_colors = 0
if &t_Co == 256 && filereadable($HOME . "/.themes/current/terminal/256-theme")
	" get color values from theme file
	for line in readfile($HOME . "/.themes/current/terminal/256-theme")
		let sline = split(line,"[= ]")
		"echo len(sline)
		if len(sline) >= 2
			if sline[0] == "NORMAL_FOREGROUND"
				let theme_normal_fg = sline[1]
			elseif sline[0] == "NORMAL_BACKGROUND"
				let theme_normal_bg = sline[1]
			elseif sline[0] == "HIGHLIGHT_FOREGROUND"
				let theme_highlight_fg = sline[1]
			elseif sline[0] == "HIGHLIGHT_BACKGROUND"
				let theme_highlight_bg = sline[1]
			elseif sline[0] == "INSENSITIVE_FOREGROUND"
				let theme_insensitive_fg = sline[1]
			elseif sline[0] == "INSENSITIVE_BACKGROUND"
				let theme_insensitive_bg = sline[1]
			elseif sline[0] == "MISCELLANEOUS_FOREGROUND"
				let theme_miscellaneous_fg = sline[1]
			elseif sline[0] == "MISCELLANEOUS_BACKGROUND"
				let theme_miscellaneous_bg = sline[1]
			elseif sline[0] == "MISCELLANEOUS2_FOREGROUND"
				let theme_miscellaneous2_fg = sline[1]
			elseif sline[0] == "MISCELLANEOUS2_BACKGROUND"
				let theme_miscellaneous2_bg = sline[1]
			elseif sline[0] == "MISCELLANEOUS3_FOREGROUND"
				let theme_miscellaneous3_fg = sline[1]
			elseif sline[0] == "MISCELLANEOUS3_BACKGROUND"
				let theme_miscellaneous3_bg = sline[1]
			elseif sline[0] == "MISCELLANEOUS4_FOREGROUND"
				let theme_miscellaneous4_fg = sline[1]
			elseif sline[0] == "MISCELLANEOUS4_BACKGROUND"
				let theme_miscellaneous4_bg = sline[1]
			elseif sline[0] == "ERROR_FOREGROUND"
				let theme_error_fg = sline[1]
			elseif sline[0] == "ERROR_BACKGROUND"
				let theme_error_bg = sline[1]
			elseif sline[0] == "ERROR2_FOREGROUND"
				let theme_error2_fg = sline[1]
			elseif sline[0] == "ERROR2_BACKGROUND"
				let theme_error2_bg = sline[1]
			endif
		endif
	endfor
	let loaded_colors = 1
endif

if loaded_colors
	" ------------------------------------------------------------------------------
	" - general_syntax_(theme)                                                     -
	" ------------------------------------------------------------------------------
	execute "highlight Comment    cterm   = NONE"
	execute "highlight Comment    ctermfg = " . theme_insensitive_fg
	execute "highlight Comment    ctermbg = " . theme_insensitive_bg
	execute "highlight Constant   cterm   = NONE"
	execute "highlight Constant   ctermfg = " . theme_miscellaneous3_fg
	execute "highlight Constant   ctermbg = " . theme_miscellaneous3_bg
	execute "highlight Error      cterm   = NONE"
	execute "highlight Error      ctermfg = " . theme_miscellaneous2_fg
	execute "highlight Error      ctermbg = " . theme_miscellaneous2_bg
	execute "highlight Identifier cterm   = NONE"
	execute "highlight Identifier ctermfg = " . theme_miscellaneous3_fg
	execute "highlight Identifier ctermbg = " . theme_miscellaneous3_bg
	execute "highlight PreProc    cterm   = NONE"
	execute "highlight PreProc    ctermfg = " . theme_miscellaneous2_fg
	execute "highlight PreProc    ctermbg = " . theme_miscellaneous2_bg
	execute "highlight Special    cterm   = NONE"
	execute "highlight Special    ctermfg = " . theme_miscellaneous_fg
	execute "highlight Special    ctermbg = " . theme_miscellaneous_bg
	execute "highlight Statement  cterm   = NONE"
	execute "highlight Statement  ctermfg = " . theme_miscellaneous_fg
	execute "highlight Statement  ctermbg = " . theme_miscellaneous_bg
	execute "highlight Type       cterm   = NONE"
	execute "highlight Type       ctermfg = " . theme_miscellaneous4_fg
	execute "highlight Type       ctermbg = " . theme_miscellaneous4_bg
	execute "highlight Todo       cterm   = NONE"
	execute "highlight Todo       ctermfg = " . theme_highlight_fg
	execute "highlight Todo       ctermbg = " . theme_highlight_bg
	if exists('&relativenumber')
		execute "highlight CursorLineNr cterm   = NONE"
		execute "highlight CursorLineNr ctermfg = " . theme_normal_fg
		execute "highlight CursorLineNr ctermbg = " . theme_normal_bg
	endif
	execute "highlight ColorColumn cterm   = NONE"
	execute "highlight ColorColumn ctermfg = " . theme_insensitive_bg
	execute "highlight ColorColumn ctermbg = " . theme_insensitive_fg
	" spelling
	highlight clear SpellBad
	highlight SpellBad cterm=underline

" ------------------------------------------------------------------------------
" - vim_chrome_(theme)                                                         -
" ------------------------------------------------------------------------------

	execute "highlight LineNr       cterm   = None"
	execute "highlight LineNr       ctermfg = " . theme_insensitive_fg
	execute "highlight LineNr       ctermbg = " . theme_insensitive_bg
	execute "highlight SpecialKey   cterm   = NONE"
	execute "highlight SpecialKey   ctermfg = " . theme_insensitive_fg
	execute "highlight SpecialKey   ctermbg = " . theme_insensitive_bg
	execute "highlight Folded       cterm   = NONE"
	execute "highlight Folded       ctermfg = " . theme_insensitive_fg
	execute "highlight Folded       ctermbg = " . theme_insensitive_bg
	execute "highlight MatchParen   cterm   = NONE"
	execute "highlight MatchParen   ctermfg = " . theme_highlight_fg
	execute "highlight MatchParen   ctermbg = " . theme_highlight_bg
	execute "highlight NonText      cterm   = NONE"
	execute "highlight NonText      ctermfg = " . theme_insensitive_fg
	execute "highlight NonText      ctermbg = " . theme_insensitive_bg
	execute "highlight Search       cterm   = NONE"
	execute "highlight Search       ctermfg = " . theme_highlight_fg
	execute "highlight Search       ctermbg = " . theme_highlight_bg
	execute "highlight ModeMsg      cterm   = NONE"
	execute "highlight ModeMsg      ctermfg = " . theme_insensitive_fg
	execute "highlight ModeMsg      ctermbg = " . theme_insensitive_bg
	execute "highlight MoreMsg      cterm   = NONE"
	execute "highlight MoreMsg      ctermfg = " . theme_insensitive_fg
	execute "highlight MoreMsg      ctermbg = " . theme_insensitive_bg
	execute "highlight Pmenu        cterm   = NONE"
	execute "highlight Pmenu        ctermfg = " . theme_normal_fg
	execute "highlight Pmenu        ctermbg = " . theme_normal_bg
	execute "highlight PmenuSel     cterm   = NONE"
	execute "highlight PmenuSel     ctermfg = " . theme_highlight_fg
	execute "highlight PmenuSel     ctermbg = " . theme_highlight_bg
	execute "highlight PmenuSbar    cterm   = NONE"
	execute "highlight PmenuSbar    ctermfg = " . theme_error_fg
	execute "highlight PmenuSbar    ctermbg = " . theme_error_bg
	execute "highlight StatusLine   cterm   = NONE"
	execute "highlight StatusLine   ctermfg = " . theme_insensitive_fg
	execute "highlight StatusLine   ctermbg = " . theme_insensitive_bg
	execute "highlight StatusLineNC cterm   = NONE"
	execute "highlight StatusLineNC ctermfg = " . theme_insensitive_fg
	execute "highlight StatusLineNC ctermbg = " . theme_insensitive_bg
	execute "highlight TabLine      cterm   = NONE"
	execute "highlight TabLine      ctermfg = " . theme_insensitive_fg
	execute "highlight TabLine      ctermbg = " . theme_insensitive_bg
	execute "highlight TabLineFill  cterm   = NONE"
	execute "highlight TabLineFill  ctermbg = " . theme_normal_bg
	execute "highlight TabLineSel   cterm   = NONE"
	execute "highlight TabLineSel   ctermfg = " . theme_highlight_fg
	execute "highlight TabLineSel   ctermbg = " . theme_highlight_bg
	execute "highlight Title        cterm   = NONE"
	execute "highlight Title        ctermfg = " . theme_insensitive_fg
	execute "highlight Title        ctermbg = " . theme_insensitive_bg
	execute "highlight VertSplit    cterm   = NONE"
	execute "highlight VertSplit    ctermfg = " . theme_insensitive_fg
	execute "highlight VertSplit    ctermbg = " . theme_insensitive_bg
	execute "highlight Visual       cterm   = NONE"
	execute "highlight Visual       ctermfg = " . theme_normal_bg
	execute "highlight Visual       ctermbg = " . theme_normal_fg
	execute "highlight SignColumn   ctermbg = " . theme_normal_bg
	execute "highlight DiffAdd      cterm   = NONE"
	execute "highlight DiffAdd      ctermfg = NONE"
	execute "highlight DiffAdd      ctermbg = NONE"
	execute "highlight DiffChange   cterm   = NONE"
	execute "highlight DiffChange   ctermfg = NONE"
	execute "highlight DiffChange   ctermbg = NONE"
	execute "highlight DiffDelete   cterm   = NONE"
	execute "highlight DiffDelete   ctermfg = NONE"
	execute "highlight DiffDelete   ctermbg = NONE"
	execute "highlight DiffText     cterm   = NONE"
	execute "highlight DiffText     ctermfg = NONE"
	execute "highlight DiffText     ctermbg = NONE"
	execute "highlight FoldColumn   cterm   = NONE"
	execute "highlight FoldColumn   ctermfg = " . theme_normal_fg
	execute "highlight FoldColumn   ctermbg = " . theme_normal_bg
	execute "highlight SpellRare    ctermfg = NONE"
	execute "highlight SpellRare    ctermbg = NONE"
else
	"	echoerr "Could not load 'currentterm' theme - probably problem with t_Co or ~/.themes/current/terminal/<t_Co>-theme"
endif
