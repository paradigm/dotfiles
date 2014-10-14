" ==============================================================================
" = diffsigns                                                                  =
" ==============================================================================

function! diffsigns#run()
	" setup signs
	sign define added   text=++ texthl=DiffAdd
	sign define deleted text=-- texthl=DiffDelete
	sign define changed text=!! texthl=DiffChange
	sign unplace *
	" setup diff
	let opt = ""
	if &diffopt =~ "icase"
		let opt = opt . "-i "
	endif
	if &diffopt =~ "iwhite"
		let opt = opt . "-b "
	endif
	" run diff
	silent execute "!diff -a --binary " . opt . v:fname_in . " " . v:fname_new . " > " . v:fname_out

	" if there's no difference, we can just abort here
	if readfile(v:fname_out) == []
		return
	endif

	" pre-parse diff to find which buffer was "fname_in" and which buffer was "fname_new"
	" 0 means we don't have any idea
	" <0 means we know if there's only two diff windows, but if not we could still be wrong, keep look
	" >0 means we found it
	let in_buf = 0
	let new_buf = 0
	for line in readfile(v:fname_out)
		" we only care about the lines that tell us which lines were changed, not the actual changes
		if line !~ "^[0-9]"
			continue
		endif
		let in_side = split(line, "[acd]")[0] " A,B
		let new_side = split(line, "[acd]")[1] " C,D"
		let changetype = split(line, "[0-9,]")[0] "c"
		if in_side =~ ","
			let in_start = split(in_side, ",")[0]
		else
			let in_start = in_side
		endif
		if new_side =~ ","
			let new_start = split(new_side, ",")[0]
		else
			let new_start = new_side
		endif
		if changetype == "a"
			let new_line = readfile(v:fname_new)[new_start-1]
			for win in range(1, winnr("$"))
				if getwinvar(win, '&diff')
					if getbufline(winbufnr(win),new_start)[0] == new_line
						let new_buf = winbufnr(win)
					else
						if in_buf == 0
							let in_buf = -winbufnr(win)
						endif
					endif
				endif
			endfor
		elseif changetype == "d"
			let in_line = readfile(v:fname_in)[in_start-1]
			for win in range(1, winnr("$"))
				if getwinvar(win, '&diff')
					if getbufline(winbufnr(win),in_start)[0] == in_line
						let in_buf = winbufnr(win)
					else
						if new_buf == 0
							let new_buf = -winbufnr(win)
						endif
					endif
				endif
			endfor
		elseif changetype == "c"
			let new_line = readfile(v:fname_new)[new_start-1]
			for win in range(1, winnr("$"))
				if getwinvar(win, '&diff')
					if getbufline(winbufnr(win),new_start)[0] == new_line
						let new_buf = winbufnr(win)
						break
					endif
				endif
			endfor
			let in_line = readfile(v:fname_in)[in_start-1]
			for win in range(1, winnr("$"))
				if getwinvar(win, '&diff')
					if getbufline(winbufnr(win),in_start)[0] == in_line
						let in_buf = winbufnr(win)
						break
					endif
				endif
			endfor
		endif
		if new_buf > 0 && in_buf > 0
			break
		endif
	endfor

	if new_buf < 0
		" couldn't find it for sure, but we've probably got it
		let new_buf = new_buf * -1
	endif
	if in_buf < 0
		" couldn't find it for sure, but we've probably got it
		let in_new = in_buf * -1
	endif
	if new_buf == 0 || in_buf == 0
		echohl ErrorMsg
		echo "DiffSigns: Could not find both diff windows"
		echohl None
	endif

	for line in readfile(v:fname_out)
		" we only care about the lines that tell us which lines were changed, not the actual changes
		if line !~ "^[0-9]"
			continue
		endif
		let in_side = split(line, "[acd]")[0]
		let new_side = split(line, "[acd]")[1]
		let changetype = split(line, "[0-9,]")[0]
		if in_side =~ ","
			let in_start = split(in_side, ",")[0]
			let in_end = split(in_side, ",")[1]
		else
			let in_start = in_side
			let in_end = in_side
		endif
		if new_side =~ ","
			let new_start = split(new_side, ",")[0]
			let new_end = split(new_side, ",")[1]
		else
			let new_start = new_side
			let new_end = new_side
		endif
		if changetype == "a"
			let new_signtype = "added"
			let in_signtype = "deleted"
		elseif changetype == "d"
			let new_signtype = "deleted"
			let in_signtype = "added"
		elseif changetype == "c"
			let new_signtype = "changed"
			let in_signtype = "changed"
		else
			let new_signtype = "???"
			let in_signtype = "???"
		endif
		for linenr in range(new_start, new_end)
			if new_signtype != "deleted" && new_buf != ""
				execute "sign place 1 line=" . linenr . " name=" . new_signtype . " buffer=" . new_buf
			endif
		endfor
		for linenr in range(in_start, in_end)
			if in_signtype != "deleted" && in_buf != ""
				execute "sign place 1 line=" . linenr . " name=" . in_signtype . " buffer=" . in_buf
			endif
		endfor
	endfor
endfunction

