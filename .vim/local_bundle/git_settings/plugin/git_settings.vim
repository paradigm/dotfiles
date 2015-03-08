" If in a git repo, use any tags it may have
if system("git rev-parse --show-toplevel")[0] == '/'
	execute "set tags+=" . system("git rev-parse --show-toplevel")[:-2] . "/.git/tags"
endif
