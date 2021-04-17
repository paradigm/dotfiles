function! languagetool#Check()
	let buf = join(getline(0, "$"),"\n")
	let languagetool = "languagetool -c utf-8 -d WHITESPACERULE,EN_QUOTES -l en-US --json -"
	let cmd = "echo " . shellescape(buf) . " | " . languagetool
	let results = system(cmd)
	let json = json_decode(split(results, "\n")[2])
	let results = []
	for match in json["matches"]
		let entry = s:make_entry(match)
		let results += [entry]
	endfor
	call setloclist(winnr(), results, "r")
	call support#ll()
endfunction

function! s:make_entry(match)
	let lnum = 1
	let col = a:match["offset"] + 1
	for line in getline(0, "$")
		if len(line) > col
			let rv = {}
			let rv["lnum"] = lnum
			let rv["col"] = col
			let rv["line"] = getline(lnum)
			let rv["filename"] = expand("%")
			let rv["type"] = ">"
			let substr = getline(lnum)[(col-1) : (col + a:match["length"] - 2)]
			let text = "\"" . substr . "\" -> " . a:match["message"]
			let first = 1
			for match in a:match["replacements"]
				if first
					let text .= "  Consider: "
					let first = 0
				else
					let text .= " or "
				endif
				let text .= "\"" . match["value"] . "\""
			endfor
			let rv["text"] = text
			return rv
		endif
		let lnum += 1
		let col -= len(line) + 1
	endfor
endfunction
