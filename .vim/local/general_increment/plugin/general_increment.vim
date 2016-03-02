let g:general_increment_table = [
			\ ["true", "false"],
			\ ["yes", "no"],
			\ ["on", "off"],
			\ ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"],
			\ ["january", "february", "march", "april", "may", "june", "july", "august", "september", "october", "december"],
			\ ]

nnoremap <space>a :<c-u>call general_increment#next(1)<cr>
nnoremap <space>x :<c-u>call general_increment#next(-1)<cr>
