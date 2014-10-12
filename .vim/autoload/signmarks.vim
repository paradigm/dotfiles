" ==============================================================================
" = sigmmarks                                                                  =
" ==============================================================================

" show marks in sign column
function! signmarks#run()
	sign unplace *
	for mark in ["}","{",")","(","`",".","^",'"',"'",">","<","]","[" ,"9","8","7","6","5","4","3","2","1","0","Z","Y","X","W","V","U","T","S","R","Q","P","O","N","M","L","K","J","I","H","G","F","E","D","C","B","A" ,"z","y","x","w","v","u","t","s","r","q","p","o","n","m","l","k","j","i","h","g","f","e","d","c","b","a"]
		let char = mark
		let pos = getpos("'" . char)
		if pos != [0,0,0,0]
			if pos[0] != 0
				let bufnr = pos[0]
			else
				let bufnr = bufnr("%")
			endif
			execute "sign define mark" . char . " text='" . char . " texthl=NonText"
			execute "sign place 1 line=" . pos[1] . " name=mark" . char . " buffer=" . bufnr
		endif
	endfor
endfunction

