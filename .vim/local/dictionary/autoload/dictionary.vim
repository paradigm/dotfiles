" parse page for definitions
function! s:dictionary_fmt(inline, indent)
		let line = a:inline
		let line = substitute(line, '   *', ' ', 'g')
		let line = substitute(line, '<[^>]\+>', '', 'g')
		let line = substitute(line, '^[ \t\r\n]*', '', 'g')
		if line =~ "^[ \t\r\n]*$"
			return ""
		endif
		return "|" . a:indent . line
endfunction

function! dictionary#dictionary_add(word)
	if &dictionary == ""
		redraw
		echohl ErrorMsg
		echo "No dictionary file location set"
		echohl None
		call input("ENTER to continue")
		return
	endif
	let dictionaryfile = split(&dictionary,'\\\@<!,')[-1]

	" check if given word is already in local dictionary
	if filereadable(dictionaryfile)
		for line in readfile(dictionaryfile)
			if match(line, "^" . a:word . "|") != -1
				return
			endif
		endfor
	endif

	" we don't yet have the word, get the dictionary.com page
	let out = tempname()
	redraw
	echo "Looking up \"" . a:word . "\"..."
	call system("wget -qO " . out . " 'http://dictionary.com/browse/" . a:word . "'")
	if !filereadable(out)
		redraw!
		echohl ErrorMsg
		echo "Could not find " . a:word . " at dictionary.com"
		echohl None
		call input("ENTER to continue")
		return
	endif

	let defline = a:word
	let last_line = ""
	let in_sublist = 0
	for line in readfile(out)
		" synonyms are put in an awkward place, just remove them
		if match(line, "def-block-label-synonyms") != -1
			let line = substitute(line, '<[^>]*def-block-label-synonyms.*', '', 'g')
		endif
		" pronunciation
		if match(line, "spellpron") != -1
			let defline .= s:dictionary_fmt(line, "")
		endif
		" part of speech
		if match(line, "dbox-pg") != -1
			let defline .= s:dictionary_fmt(line, "")
		endif
		" definition number
		if match(line, "def-number") != -1
			let defline .= s:dictionary_fmt(line, "")
		endif
		" definition
		if match(last_line, "def-content") != -1
			let defline .= s:dictionary_fmt(line, "  ")
		endif
		" sub-definition
		if match(last_line, "def-sub-list") != -1
			let in_sublist = 1
		endif
		if match(last_line, "<li>") != -1 && in_sublist
			let defline .= s:dictionary_fmt(line, "  - ")
		endif
		if match(last_line, "</ol>") != -1
			let in_sublist = 0
		endif
		let last_line = line
	endfor

	" append definition to local dictionary
	if filereadable(dictionaryfile)
		let dictionary = readfile(dictionaryfile)
	else
		let dictionary = []
	endif
	let dictionary += [defline]
	call writefile(dictionary, dictionaryfile)

	echon " done"
endfunction

function! dictionary#thesaurus_add(word)
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

	echon " done"
endfunction

function! dictionary#define(word)
	if &dictionary == ""
		redraw
		echohl ErrorMsg
		echo "No dictionary file location set"
		echohl None
		call input("ENTER to continue")
		return
	endif
	let dictionaryfile = split(&dictionary,'\\\@<!,')[-1]

	call dictionary#dictionary_add(a:word)
	let defline = ""
	let found = 0
	if filereadable(dictionaryfile)
		for line in readfile(dictionaryfile)
			if match(line, "^" . a:word . "|") != -1
				let defline = line
				break
			endif
		endfor
	endif

	for line in split(defline, '|')
		echo line
	endfor
endfunction

function! dictionary#synonymize(word)
	if &thesaurus == ""
		redraw
		echohl ErrorMsg
		echo "No thesaurus file location set"
		echohl None
		call input("ENTER to continue")
		return
	endif
	let thesaurusfile = split(&thesaurus,'\\\@<!,')[-1]

	call dictionary#thesaurus_add(a:word)
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
	
	for word in split(line)
		echo word
	endfor
endfunction
