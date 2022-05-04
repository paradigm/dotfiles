function! s:get_dictionary_file()
	if &dictionary == ""
		redraw
		echohl ErrorMsg
		echo "No dictionary file location set"
		echohl None
		call input("ENTER to continue")
		return ""
	endif
	return split(&dictionary,'\\\@<!,')[-1]
endfunction

function! dictionary#dictionary_add(word)
	let dictionaryfile = s:get_dictionary_file()
	if dictionaryfile == ""
		return
	end

	if filereadable(dictionaryfile)
		for line in readfile(dictionaryfile)
			if match(line, "^" . a:word . "|") != -1
				return
			endif
		endfor
	endif

	redraw

	let apikey = systemlist("echo 'dictionaryapi.com-dictionary-api-key' | ekvs quiet get")
	if len(apikey) == 0
		echohl ErrorMsg
		echo "Could not query keyring for api key"
		echohl None
		call input("ENTER to continue")
		return
	endif
	let cmd = "curl 2>/dev/null 'https://dictionaryapi.com/api/v3/references/collegiate/json/'"
	let cmd .= shellescape(a:word)
	let cmd .= "'?key='"
	let cmd .= shellescape(apikey[0])
	let response = system(cmd)

	if filereadable(dictionaryfile)
		let dictionary = readfile(dictionaryfile)
	else
		let dictionary = []
	endif
	let dictionary += [a:word . "|" . response]
	call writefile(dictionary, dictionaryfile)
endfunction

function! dictionary#define(word)
	let dictionaryfile = s:get_dictionary_file()
	if dictionaryfile == ""
		return
	end

	call dictionary#dictionary_add(a:word)
	let found = 0
	if filereadable(dictionaryfile)
		for line in readfile(dictionaryfile)
			if match(line, "^" . a:word . "|") != -1
				let definition = json_decode(substitute(line, "^[^|]*|", "", ""))
				break
			endif
		endfor
	endif

	echo a:word
	echo ""
	echon definition[0]['hwi']['hw']
	for pronunciation in definition[0]['hwi']['prs']
		echon "| "
		echon pronunciation['mw']
	endfor
	echo ""
	let nr = 0
	for definition in definition[0]['shortdef']
		let nr += 1
		echo nr . ". " . definition
	endfor
endfunction

function! s:get_thesaurus_file()
	if &thesaurus == ""
		redraw
		echohl ErrorMsg
		echo "No thesaurus file location set"
		echohl None
		call input("ENTER to continue")
		return ""
	endif
	return split(&thesaurus,'\\\@<!,')[-1]
endfunction

function! dictionary#thesaurus_add(word)
	let thesaurusfile = s:get_thesaurus_file()
	if thesaurusfile == ""
		return
	end

	if filereadable(thesaurusfile)
		for line in readfile(thesaurusfile)
			if len(split(line)) > 0 && split(line)[0] == a:word
				return
			endif
		endfor
	endif

	redraw

	let apikey = systemlist("echo 'dictionaryapi.com-thesaurus-api-key' | ekvs quiet get")
	if len(apikey) == 0
		echohl ErrorMsg
		echo "Could not query keyring for api key"
		echohl None
		call input("ENTER to continue")
		return
	endif
	let cmd = "curl 2>/dev/null 'https://dictionaryapi.com/api/v3/references/thesaurus/json/'"
	let cmd .= shellescape(a:word)
	let cmd .= "'?key='"
	let cmd .= shellescape(apikey[0])
	let response = system(cmd)

	let entry = a:word
	for group in json_decode(response)[0]['meta']['syns']
		for synonym in group
			let entry .= ' ' . synonym
		endfor
	endfor

	if filereadable(thesaurusfile)
		let thesaurus = readfile(thesaurusfile)
	else
		let thesaurus = []
	endif
	let thesaurus += [entry]
	call writefile(thesaurus, thesaurusfile)
endfunction

function! dictionary#synonymize(word)
	let thesaurusfile = s:get_thesaurus_file()
	if thesaurusfile == ""
		return
	end

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
