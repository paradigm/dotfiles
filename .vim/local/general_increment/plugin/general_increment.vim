let g:general_increment_table = [
			\ ["true", "false"],
			\ ["True", "False"],
			\ ["TRUE", "FALSE"],
			\ ]

nnoremap <space>a :call general_increment#increment()<cr>
nnoremap <space>x :call general_increment#decrement()<cr>
