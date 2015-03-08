function! thesaurus#populate(word)
	if &thesaurus == ""
		redraw
		echohl ErrorMsg
		echo "No thesaurus file location set"
		echohl None
		call input("ENTER to continue")
		return
	endif
	let thesaurusfile = split(&thesaurus,'\\\@<!,')[-1]

	" check if given word is already in local thesaurus
	if filereadable(thesaurusfile)
		for line in readfile(thesaurusfile)
			if match(line, "^" . a:word . " ") != -1
				return
			endif
		endfor
	endif

	" we don't yet have the word, get the thesaurus.com page
	let out = tempname()
	echo "Looking up \"" . a:word . "\"..."
	call system("wget -qO " . out . " 'http://thesaurus.com/browse/" . a:word . "'")
	if !filereadable(out)
		redraw
		echohl ErrorMsg
		echo "Could not find " . a:word . " at thesaurus.com"
		echohl None
		call input("ENTER to continue")
		return
	endif

	" parse page for synonyms
	let results = []
	for line in readfile(out)
		let fields = split(line, "\<\\|\>\\|&quot;")
		if len(fields) > 2 && fields[0] == 'span class="text"'
			let results += [fields[1]]
		endif
	endfor

	" append synonyms to local thesaurus
	if filereadable(thesaurusfile)
		let thesaurus = readfile(thesaurusfile)
	else
		let thesaurus = []
	endif
	let thesaurus += [a:word . ' ' . join(results)]
	call writefile(thesaurus, thesaurusfile)
endfunction

function! thesaurus#preview_synonyms(word)
	if &thesaurus == ""
		redraw
		echohl ErrorMsg
		echo "No thesaurus file location set"
		echohl None
		call input("ENTER to continue")
		return
	endif
	let thesaurusfile = split(&thesaurus,'\\\@<!,')[-1]

	call thesaurus#populate(a:word)
	let found = 0
	for line in readfile(thesaurusfile)
		let fields = split(line)
		if fields[0] == a:word
			let found = 1
			break
		endif
	endfor
	if !found
		echo "No matches"
		return
	endif
	let out = tempname()
	call writefile([line], out)
	execute "pedit! " . out
	wincmd P
	setlocal nomodifiable
	normal! gg
	setlocal bufhidden=delete
	redraw!
endfunction
