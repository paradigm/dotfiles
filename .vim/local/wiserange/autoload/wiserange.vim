" ==============================================================================
" = wiserange                                                                  =
" ==============================================================================
"
" Note: accepts but ignores range provided in front of it, as vim only passes
" along lines (making it useless)

function! wiserange#prepend_cmdline()
	if mode() ==# "v"
		return "\<home>CW \<end>"
	elseif mode() ==# "V"
		return ""
	elseif mode() ==# "\<c-v>"
		return "\<home>BW \<end>"
	else
		return ""
	endif
endfunction

function! wiserange#char(...)
	call s:main("v", join(a:000))
endfunction

function! wiserange#line(...)
	call s:main("V", join(a:000))
endfunction

function! wiserange#block(...)
	call s:main("\<c-v>", join(a:000))
endfunction

" Parses the range information out of the provided input
function! s:parse_range(cmd)
	let cmd = a:cmd

	" remove any leading whitespace
	let cmd = substitute(cmd, '^\s*', '', '')

	" look for start of range
	if cmd =~ "^'[a-zA-Z0-9<>['\"^.(){}]" || cmd[0:1] == "']"
		let start = cmd[0:1]
		let cmd = cmd[2:]
	elseif cmd =~ '^[0-9.$%/?]'
		return [-1, -1, -1] " invalid range
	else
		return ["", "", cmd]
	endif

	" remove any leading whitespace
	let cmd = substitute(cmd, '^\s*', '', '')

	" look for a comma to indicate another side to the range.
	if cmd[0] == ","
		let cmd = cmd[1:]
	else
		return [start, start, cmd]
	endif

	" remove any leading whitespace
	let cmd = substitute(cmd, '^\s*', '', '')

	" look for end of range
	if cmd =~ "^'[a-zA-Z0-9<>['\"^.(){}]" || cmd[0:1] == "']"
		let end = cmd[0:1]
		let cmd = cmd[2:]
	elseif cmd =~ '^[0-9.$%/?]'
		return [-1, -1, -1] " invalid range
	else
		return [start, start, cmd]
	endif

	return [start, end, cmd]
endfunction

function! s:get_pastecmd(wise, quotestart, quoteend, dollar_state)
	" Figure out if we need to `p` or `P` content back in.  The
	" determining factor is whether or not the character the cursor lands
	" on is before or after the region being removed (and then re-added),
	" which in turn is dependent on what "follows" the region.
	if a:wise ==# "v"
		if col(a:quoteend) == strlen(getline(line(a:quoteend)))
			return "p"
		else
			return "P"
		endif
	elseif a:wise ==# "V"
		if line(a:quoteend) == line("$")
			return "p"
		else
			return "P"
		endif
	elseif a:wise ==# "\<c-v>"
		if col(a:quoteend) >= strlen(getline(line(a:quotestart))) || a:dollar_state != "off"
			return "p"
		else
			return "P"
		endif
	else
		echoerr "WiseRange: illegal 'wise' provided: " . a:wise
		exit 2
	endif
endfunction

function! s:get_dollar_state(quotestart, quoteend)
	if col(a:quotestart) > strlen(getline(line(a:quotestart)))
		return "top"
	elseif col(a:quoteend) > strlen(getline(line(a:quoteend)))
		return "bottom"
	else
		return "off"
	endif
endfunction

function! s:main(wise, cmd)
	" parse out range from cmdline
	let [quotestart, quoteend, cmd] = s:parse_range(a:cmd)

	if quotestart == -1
		echohl ErrorMsg
		echo "WiseRange: non-mark provided in range, aborting"
		echohl Normal
		return
	endif

	if quotestart == ""
		" no range specified, just run the command normally.
		execute a:cmd
		return
	endif

	let tickstart = "`" . quotestart[1]
	let tickend = "`" . quoteend[1]

	" back up things we may change
	let unnamedreg = @"
	let starreg = @*

	" get context
	let line_start = line(quotestart)
	let line_end = line(quoteend)
	let lines_before = line(quotestart)-1
	let lines_after = line("$") - line(quoteend)

	let dollar_state = s:get_dollar_state(quotestart, quoteend)

	let pastecmd = s:get_pastecmd(a:wise, quotestart, quoteend, dollar_state)

	" cut content
	if dollar_state == "off"
		execute "normal! " . tickstart . "d" . a:wise . tickend
	elseif dollar_state == "top"
		execute "normal! " . tickend . a:wise . tickstart . "$d"
	elseif dollar_state == "bottom"
		execute "normal! " . tickstart . a:wise . tickend . "$d"
	endif

	" paste into temporary buffer
	new
	call support#scratch()
	put
	1d _

	" create context
	if lines_before != 0
		execute "normal! gg" . lines_before . "O"
	endif
	if lines_after != 0
		execute "normal! G" . lines_after . "o"
	endif

	" apply command
	if quotestart != quoteend
		execute line_start . "," . line_end . cmd
	else
		execute line_start . cmd
	endif

	" cut updated content
	if lines_before != 0
		execute "silent 1," . lines_before . "d"
	endif
	if lines_after != 0
		execute "silent " . (line("$") - lines_after + 1) . ",$d"
	endif
	execute "silent normal! gg" . a:wise . "G$d"

	" close temporary buffer
	q

	" insert update content
	execute "undojoin | normal! " . pastecmd

	" restore state
	let @* = starreg
	let @" = unnamedreg
endfunction
