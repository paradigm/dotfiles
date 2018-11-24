function! next_previous#do_while(cmd, changes, stays)
	execute 'let current_changes = ' . a:changes
	execute 'let current_stays = ' . a:stays
	let previous_changes = current_changes
	let previous_stays = current_stays
	let first_round = 1

	while 1
		if previous_changes == current_changes && !first_round
			break
		endif
		if previous_stays != current_stays
			break
		endif
		let previous_changes = current_changes
		let previous_stays = current_stays
		execute a:cmd
		execute 'let current_changes = ' . a:changes
		execute 'let current_stays = ' . a:stays
		let first_round = 0
	endwhile
endfunction
