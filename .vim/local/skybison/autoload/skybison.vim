" Alternative interface to the Vim command line
" Maintainer: Daniel Thau (paradigm@bedrocklinux.org)
" Version: 2.0
" Description: SkyBison is an alternative interface to the Vim command line
" Last Change: 2013-05-18
" Location: plugin/SkyBison.vim
" Website: https://github.com/paradigm/skybison
"
" See skybison.txt for documentation.

scriptencoding utf-8

"" backwards compatibility for 1.X series
"function! Skybison(initcmdline)
"	call skybison#run(a:initcmdline)
"endfunction
"
" Switch from normal cmdline to skybison
" cnoremap <c-l>     <c-\>eskybison#cmdline_switch()<cr><cr>

" Launch skybison
"
" nnoremap <leader>: :call skybison()<cr>
function! skybison#run(...)
	" skybison cannot run from the cmdline window, as
	" window-splitting/moving commands are verboten there.
	if exists("b:cmdline_window_running") && b:cmdline_window_running
		redraw
		echohl ErrorMsg
		echo "SkyBison: cannot be run from cmdline-window"
		echohl Normal
		return
	endif
	" skybison should not be run recursively, abort if it is already
	" running
	if exists("s:running") && s:running
		redraw
		echohl ErrorMsg
		echo "SkyBison: cannot run recursively"
		echohl Normal
		return
	endif
	let s:running = 1

	" if first argument exists, use that as initial cmdline
	if a:0 > 0
		let s:init_cmdline = a:1
	else
		let s:init_cmdline = ""
	endif
	" if second argument exists, use it as count.  Otherwise, use v:count.
	if a:0 > 1
		let s:count = a:2
	else
		let s:count = v:count
	endif
	" do setup
	noautocmd call s:setup_vars()
	noautocmd call s:setup_windows(s:init_cmdline)
	set filetype=skybison
	set syntax=vim " use vim syntax highlighting
	noautocmd call s:setup_maps()
	noautocmd call s:setup_autocmds()

	" user settings
	silent doautocmd User skybison_setup

	" start insert on bottom-most line
	call cursor(line("$"), 1)
	startinsert!
endfunction

function! skybison#cmdline_switch()
	return "call skybison#run('" . escape(getcmdline(),"'") . "')"
endfunction

" If there is only one completion item available, complete it and accept.
" Otherwise, just accept.
"
" autocmd Filetype skybison inoremap <buffer> <silent> <cr> <esc>:call skybison#accept_complete()<cr>
" autocmd Filetype skybison nnoremap <buffer> <silent> <cr>      :call skybison#accept_complete()<cr>
function! skybison#accept_complete()
	let cmdline = getline(".")
	if len(s:results) == 1
		let cmdline = substitute(cmdline, '\v(\S|\\\s)+$', '', '') . s:results[0]
	endif
	call s:quit(cmdline)
endfunction

" Accept current line literally.
"
" autocmd Filetype skybison inoremap <buffer> <silent> <c-v><cr> <esc>:call skybison#accept_literal()<cr>
" autocmd Filetype skybison nnoremap <buffer> <silent> <c-v><cr>      :call skybison#accept_literal()<cr>
function! skybison#accept_literal()
	call s:quit(getline("."))
endfunction

" Quit
"
" autocmd Filetype skybison nnoremap <buffer> <silent> <esc> :call skybison#quit()<cr>
" autocmd Filetype skybison nnoremap <buffer> <silent> <c-c> :call skybison#quit()<cr>
function! skybison#quit()
	call s:quit()
endfunction

" Scroll completion window contents down by one
"
" autocmd Filetype skybison inoremap <buffer> <silent> <c-e> <c-o>:call skybison#scroll_down()<cr>
" autocmd Filetype skybison nnoremap <buffer> <silent> <c-e>      :call skybison#scroll_down()<cr>
function! skybison#scroll_down()
	let s:offset += 1
	if s:offset >= len(s:results)
		let s:offset = len(s:results)-1
	endif
	call s:update_comp(getline("."))
endfunction

" Scroll completion window contents up by one
"
" autocmd Filetype skybison inoremap <buffer> <silent> <c-y> <c-o>:call skybison#scroll_up()<cr>
" autocmd Filetype skybison nnoremap <buffer> <silent> <c-y>      :call skybison#scroll_up()<cr>
function! skybison#scroll_up()
	let s:offset -= 1
	if s:offset < 0
		let s:offset = 0
	endif
	call s:update_comp(getline("."))
endfunction

" Scroll completion window contents down by lines in window
"
" autocmd Filetype skybison inoremap <buffer> <silent> <c-f> <c-o>:call skybison#page_down()<cr>
" autocmd Filetype skybison nnoremap <buffer> <silent> <c-f>      :call skybison#page_down()<cr>
function! skybison#page_down()
	let s:offset += s:comp_height
	if s:offset >= len(s:results)
		let s:offset = len(s:results)-1
	endif
	call s:update_comp(getline("."))
endfunction

" Scroll completion window contents down by lines in window
"
" autocmd Filetype skybison inoremap <buffer> <silent> <c-b> <c-o>:call skybison#page_up()<cr>
" autocmd Filetype skybison nnoremap <buffer> <silent> <c-b>      :call skybison#page_up()<cr>
function! skybison#page_up()
	let s:offset -= s:comp_height
	if s:offset < 0
		let s:offset = 0
	endif
	call s:update_comp(getline("."))
endfunction

" Tab-complete input, mimicking c_tab.  Mostly useful when there is only one
" completion option and completing it will reveal more options, such as with a
" :e
"
" autocmd Filetype skybison inoremap <buffer> <silent> <tab> <esc>:call skybison#tab_complete()<cr>A
" autocmd Filetype skybison inoremap <buffer> <silent> <c-l> <esc>:call skybison#tab_complete()<cr>A
function! skybison#tab_complete()
	let cmdline = getline(".")
	if len(s:results) > 0
		let l:d={}
		" Huge thanks to ZyX-I for this line
		execute "silent normal! :".l:cmdline."\<c-l>\<c-\>eextend(d, {'cmdline':getcmdline()}).cmdline\n"
		call setline(line("."), l:d['cmdline'])
	endif
endfunction

" Toggle the select functionality.  When on, entering a select key will select
" the item.  When off, entering a select key will input key literally.
"
" autocmd Filetype skybison inoremap <buffer> <silent> <c-g> <c-o>:call skybison#toggle_select()<cr>
" autocmd Filetype skybison nnoremap <buffer> <silent> <c-g>      :call skybison#toggle_select()<cr>
function! skybison#toggle_select()
	let s:select = ! s:select
	call s:update_comp(getline("."))
endfunction

function! s:setup_vars()
	" characters to use to select item
	let s:selchars_input = get(g:, "skybison_selchars_input", ["1","2","3","4","5","6","7","8","9"])
	" how characters are printed
	let s:selchars_output = get(g:, "skybison_selchars_output", s:selchars_input)
	" default with selection enabled or disabled
	let s:select = get(g:, "skybison_select", 1)
	" set completion window height = number of selection characters
	let s:comp_height = len(s:selchars_input)
	" history/input window height
	let s:hist_height = get(g:,"skybison_history_height", 1)
	" initial window number to restore later
	let s:init_winnr = winnr()
	" initial window count to restore later
	let s:init_wincnt = winnr("$")
	" initial offset
	let s:offset = 0
	"
	let s:results = []

	let s:winsizecmd = winrestcmd()
	let s:init_lazyredraw = &lazyredraw
	let &lazyredraw = 1
	let s:init_laststatus = &laststatus
	let &laststatus = 0
	let s:init_shellslash = &shellslash
	let &shellslash = 1
endfunction

function! s:setup_windows(init_cmdline)
	" make completion options window
	execute "noautocmd botright " . (s:comp_height+4) . "new"
	execute "noautocmd " . (s:comp_height+2) . "wincmd _"
	let s:comp_winnr = winnr()

	" make history/input window
	execute "noautocmd botright " . s:hist_height . "new"
	execute "noautocmd " . s:hist_height . "wincmd _"
	let s:hist_winnr = winnr()

	" set local settings in both windows
	for winnr in [s:comp_winnr, s:hist_winnr]
		" go to window
		call s:switch_win(winnr)
		" disable settings it may have inherited
		setlocal nocursorcolumn
		setlocal nocursorline
		setlocal nonumber
		setlocal nowrap
		setlocal nobuflisted
		setlocal buftype=nofile
		if exists("&relativenumber")
			setlocal norelativenumber
		endif
		" delete it when hidden
		setlocal bufhidden=delete
	endfor

	" setup completion window
	call s:switch_win(s:comp_winnr)
	silent! file [SkyBison]
	syntax match LineNr /\v^[^ ]* /
	"execute 'syntax match MoreMsg /\%'.(s:comp_height+1).'l.*/'

	" setup input/history window
	call s:switch_win(s:hist_winnr)
	" set contents from cmdline history
	for i in range(0, histnr(":"))
		call setline(i, histget(":", i))
	endfor
	" set initial contents
	call append("$", a:init_cmdline)
	" update completion based on initial contents
	call s:update_comp(a:init_cmdline)
	" signs
	sign define skybison_select text=: texthl=NonText
	for i in range(1, line("$"))
		execute "sign place ".i." line=".i." name=skybison_select buffer=" . bufnr("%")
	endfor
endfunction

function! s:setup_maps()
	if !hasmapto("skybison#accept_complete")
		inoremap <buffer> <silent> <cr> <esc>:call skybison#accept_complete()<cr>
		nnoremap <buffer> <silent> <cr>      :call skybison#accept_complete()<cr>
	endif
	if !hasmapto("skybison#accept_literal")
		inoremap <buffer> <silent> <c-v><cr> <esc>:call skybison#accept_literal()<cr>
		nnoremap <buffer> <silent> <c-v><cr>      :call skybison#accept_literal()<cr>
	endif
	if !hasmapto("skybison#quit")
		nnoremap <buffer> <silent> <esc> :call skybison#quit()<cr>
		nnoremap <buffer> <silent> <c-c> :call skybison#quit()<cr>
	endif
	if !hasmapto("skybison#scroll_down")
		inoremap <buffer> <silent> <c-e> <c-o>:call skybison#scroll_down()<cr>
		nnoremap <buffer> <silent> <c-e>      :call skybison#scroll_down()<cr>
	endif
	if !hasmapto("skybison#scroll_up")
		inoremap <buffer> <silent> <c-y> <c-o>:call skybison#scroll_up()<cr>
		nnoremap <buffer> <silent> <c-y>      :call skybison#scroll_up()<cr>
	endif
	if !hasmapto("skybison#page_down")
		inoremap <buffer> <silent> <c-f> <c-o>:call skybison#page_down()<cr>
		nnoremap <buffer> <silent> <c-f>      :call skybison#page_down()<cr>
	endif
	if !hasmapto("skybison#page_up")
		inoremap <buffer> <silent> <c-b> <c-o>:call skybison#page_up()<cr>
		nnoremap <buffer> <silent> <c-b>      :call skybison#page_up()<cr>
	endif
	if !hasmapto("skybison#tab_complete")
		inoremap <buffer> <silent> <tab> <esc>:call skybison#tab_complete()<cr>A
		inoremap <buffer> <silent> <c-l> <esc>:call skybison#tab_complete()<cr>A
	endif
	if !hasmapto("skybison#tab_complete")
		inoremap <buffer> <silent> <c-g> <c-o>:call skybison#toggle_select()<cr>
		nnoremap <buffer> <silent> <c-g>      :call skybison#toggle_select()<cr>
	endif
	for i in range(0, len(s:selchars_input)-1)
		execute "inoremap <buffer> <silent> "      . s:selchars_input[i] . " \<esc>:noautocmd call <sid>select(" . i . ")\<cr>a"
		execute "nnoremap <buffer> <silent> "      . s:selchars_input[i] . " :noautocmd call <sid>select(" . i . ")\<cr>"
		execute "inoremap <buffer> <silent> <c-v>" . s:selchars_input[i] . " " . s:selchars_input[i]
	endfor
endfunction

function! s:setup_autocmds()
	augroup SkyBison
		autocmd!
		" clean up when user leaves window
		autocmd QuitPre * call s:quit("", 1)
		autocmd WinEnter,WinLeave * call s:quit()
		" fix window sizes on resize
		autocmd VimResized * noautocmd call s:fix_win_height()
		" update comp window
		autocmd TextChanged,TextChangedI,CursorMoved,CursorMovedI * call s:update_comp(getline("."))
	augroup END
endfunction

function! s:quit(...)
	" disable autocmds
	autocmd! SkyBison
	" in case this was triggered from insert mode, stop insert
	noautocmd stopinsert
	
	let &lazyredraw = s:init_lazyredraw
	let &laststatus = s:init_laststatus
	let &shellslash = s:init_shellslash

	if a:0 > 1
		" If the user closed the skybison window by actually closing a
		" window, this was called by a quitpre autocmd and there is a
		" close-a-window queued up.  This makes things tricky.  The
		" solution used is slower than the more straight-forward one
		" and flickers.  Thus it is only used when needed.
		"
		" We only want to close one window here - the other skybison
		" window will be closed by the queued up close-a-window.
		noautocmd q
		" We can't switch to the original window now or it will be
		" closed by the queued up close-a-window.  Instead, feedkeys()
		" it. We'll also have to feedkeys() the command line.
		if a:0 > 0
			call histadd(':', a:1)
			call feedkeys(s:init_winnr . "\<c-w>w:" . s:winsizecmd . "\<cr>:" . a:1 . "\<cr>" , "n")
		else
			call feedkeys(s:init_winnr . "\<c-w>w:" . s:winsizecmd . "\<cr>" , "n")
		endif
		let s:running = 0
	else
		" The user closed skybison "normally" and we can do the
		" shutdown procedure in a straight-forward manner.
		"
		" Close both skybison windows
		noautocmd q
		noautocmd q
		execute s:winsizecmd
		execute s:init_winnr . "wincmd w"
		let s:running = 0
		if a:0 > 0
			redraw
			call histadd(':', a:1)
			execute a:1
		endif
	endif
	silent doautocmd User skybison_end
endfunction

function! <sid>select(n)
	if ! s:select
		execute "normal! a" . s:selchars_input[a:n]
		return
	endif
	let cmdline = getline(".")
	if len(s:results) > a:n + s:offset
		" append selected item
		let l:cmdline = substitute(l:cmdline, '\v(\S|\\\s)+$', '', '') . s:results[a:n + s:offset]
		call setline(line("."), l:cmdline)
		normal! $
	endif
endfunction

function! s:fix_win_height()
	" shrink windows to h=1
	noautocmd wincmd k
	noautocmd wincmd k
	while winheight(s:hist_winnr) > 1 || winheight(s:comp_winnr) > 1
		wincmd +
	endwhile
	" set window heights
	call s:switch_win(s:comp_winnr)
	execute "noautocmd " . (s:comp_height) . "wincmd _"
	call s:switch_win(s:hist_winnr)
	execute "noautocmd " . s:hist_height . "wincmd _"
endfunction

function! s:update_comp(cmdline)
	let prev_results = s:results
	call s:update_results(a:cmdline)
	if prev_results != s:results
		let s:offset = 0
	endif

	" prepend line numbering and filter out escaped whitespace
	let l:results = []
	for i in range(0, s:comp_height-1)
		if len(s:results) > (i + s:offset)
			let l:results += [(s:select ? s:selchars_output[i] : ".") . " " . substitute(s:results[i + s:offset],'\\ ',' ', 'g')]
		endif
	endfor

	" set completion window contents
	call s:switch_win(s:comp_winnr)
	%normal! "_D
	call append(0,l:results[0 : s:comp_height])
	normal! gg
	if len(s:results) == 0
		execute "silent! file <CR> to run"
	elseif len(s:results) == 1
		"call setline(s:comp_height+1, '<CR> to run complete, <C-V><CR> to run exact')
		execute "silent! file <CR> to select and run with '" . s:results[0] . "'"
	elseif len(s:results) > len(l:results)
		" not printing all results, let user know
		if s:offset == 0
			silent! file -- more below --
		elseif len(s:results) <= (len(l:results) + s:offset)
			silent! file -- more above --
		else
			silent! file -- more above and below --
		endif
	else
		execute "silent! file  "
	endif

	" update syntax highlighting
	syntax clear Identifier
	if a:cmdline != ""
		execute 'silent! syntax match Identifier /' . escape(substitute(a:cmdline, '\v^(\S|\\\s)+\s+', '\\V', ''),'/~') . '/'
	endif
	syntax clear ErrorMsg
	if s:errmsg != ""
		call setline(1, s:errmsg)
		syntax match ErrorMsg /./
	endif


	" return to hist window
	call s:switch_win(s:hist_winnr)

	" autoselect
	if len(s:results) == 1 && s:count > 0 && len(split(a:cmdline,'\\\@<!\s\+')) == s:count
		call feedkeys("\<cr>")
	endif
endfunction

function! s:update_results(cmdline)
	" go to original window
	call s:switch_win(s:init_winnr)

	" Determine cmdline-completion options.  Huge thanks to ZyX-I for
	" helping me do this so cleanly.
	let l:d={}
	try
		execute "silent normal! :".a:cmdline."\<c-a>\<c-\>eextend(l:d, {'cmdline':getcmdline()}).cmdline\n"
		let s:errmsg = ""
	catch
		let s:errmsg = v:exception
	endtry
	" If l:d was given the key 'cmdline', that will be the cmdline output
	" from c_ctrl-a.  If that is the case, strip the non-completion terms.
	" Otherwise, there was no completion - return an empty list.
	call s:switch_win(s:hist_winnr)
	if has_key(l:d, 'cmdline') && l:d['cmdline'] !~ ''
		call s:switch_win(s:hist_winnr)
		let head_len = len(split(a:cmdline,'\\\@<!\s\+'))
		if a:cmdline[-1:] !~ '\s'
			let head_len = head_len - 1 > 0 ? head_len - 1 : 0
		endif
		let s:results = split(l:d['cmdline'],'\\\@<!\s\+')[head_len : ]
	else
		call s:switch_win(s:hist_winnr)
		let s:results = []
	endif
endfunction

function! s:switch_win(winnr)
	execute "noautocmd " . a:winnr . "wincmd w"
endfunction
