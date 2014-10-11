# ==============================================================================
# = paradigm's_.zshrc                                                          =
# ==============================================================================
#
# Disclaimer: Note that I have unusual tastes.  Blindly copying lines from this
# or any of my configuration files will not necessarily result in what you will
# consider a sane system.  Please do your due diligence in ensuring you fully
# understand what will happen if you attempt to utilize content from this file,
# either in part or in full.

# ==============================================================================
# = general_settings                                                           =
# ==============================================================================
#
# These are general shell settings that don't fit well into any of the
# categories used below.

# The default permissions on newly-created files will not be readable,
# writable, or executable by anyone other than the owner of the file.
umask 077

# In bash, none of the comparable items below would be beneficial in
# non-interstice instances of the shell; thus, we'd stop sourcing the .bashrc
# here.  However, zsh does not seem to source the .zshrc file in
# non-interactive instances anyways, and so the line below is not necessary.
#[ -z "$PS1" ] && return

# If non-ambiguous, allow changing into a directory just by typing its name
# (ie, make "cd" optional)
setopt autocd

# Detect and prompt to correct typos in commands.
# Note there is a "correctall" variant which also prompts to correct arguments
# to commands, but this ends up being more troublesome than useful.
setopt correct

# Enable extended globbing functionality.
setopt extendedglob

# Disables the beep zsh would otherwise make when giving invalid input (such as
# hitting backspace on an command line).
setopt nobeep

# Do not change the nice (ie, scheduling priority) of backgrounded commands.
setopt nobgnice

# Disable flow control.  Specifically, ensure that ctrl-s does not stop
# terminal flow so that it can be used in other programs (such as Vim).
setopt noflowcontrol
stty -ixon

# Do not kill background processes when closing the shell.
setopt nohup

# Do not warn about closing the shell with background jobs running.
setopt nocheckjobs

# Do not record repeated lines in history.  Note that this line is largely
# non-functional in this .zshrc as history has not been enabled.
setopt histignoredups

# Allow comments on the command line.  Without this comments are only allowed
# in scripts.
setopt interactivecomments

# Automatically run pushd after every cd
# this allows for tab-completion on "cd -<tab>"
setopt autopushd

# ==============================================================================
# = environmental_variables                                                    =
# ==============================================================================
#
# ------------------------------------------------------------------------------
# - general_(environmental_variables)                                          -
# ------------------------------------------------------------------------------

# "/bin/zsh" should be the value of $SHELL if this config is parsed.  This line
# should not be necessary, but it's not a bad idea to have just in case.
export SHELL="/bin/zsh"

# This is where custom shell files are stored
SHELLDIR="$HOME/.zsh"
mkdir -p SHELLDIR

# Set the default text editor.
if which vim >/dev/null 2>&1
then
	export EDITOR="vim"
elif which vi >/dev/null 2>&1
then
	export EDITOR="vi"
fi

# Set the default web browser.
if [ -n "$DISPLAY" ] && which "dwb" >/dev/null 2>&1
then
	export BROWSER="dwb"
elif [ -n "$DISPLAY" ] && which "firefox" >/dev/null 2>&1
then
	export BROWSER="firefox"
elif [ -z "$DISPLAY" ] && which "elinks" >/dev/null 2>&1
then
	export BROWSER="elinks"
fi

# If in a terminal that can use 256 colors, ensure TERM reflects that fact.
if [ "$TERM" = "xterm" ]
then
	export TERM="xterm-256color"
elif [ "$TERM" = "screen" ]
then
	export TERM="screen-256color"
fi

# set PDF reader
if which mupdf >/dev/null 2>&1
then
	export PDFREADER="mupdf"
	export PDFVIEWER="mupdf"
fi

# Set the default image viewer.
if which sxiv >/dev/null 2>&1
then
	export IMAGEVIEWER="sxiv"
fi

# Set Sage's PDF/DVI/PNG browser.  This goes to a shell script which will call
# the appropriate PDF viewer or image viewer.
if which sage_browser >/dev/null 2>&1
then
	export SAGE_BROWSER="sage_browser"
fi

# sets mail directory
export MAIL="~/.mail"

# When offering typo corrections, do not propose anything which starts with an
# underscore (such as many of zsh's shell functions).
export CORRECT_IGNORE='_*'

# Do not consider "/" a word character.  One benefit of this is that when
# hitting ctrl-w in insert mode (which deletes the word before the cursor) just
# before a filesystem path, it only removes the last item of the path and not
# the entire thing.
export WORDCHARS=${WORDCHARS//\/}

# Use gpg-agent if available
export GPG_AGENT_INFO="$HOME/.gnupg/S.gpg-agent::1"

# ------------------------------------------------------------------------------
# - theme_(environmental_variables)                                            -
# ------------------------------------------------------------------------------
#
# parse theme file
if [ $(tput colors) -eq "256" ] && [ -r ~/.themes/current/terminal/256-theme ]
then
	source ~/.themes/current/terminal/256-theme

	# set the colors ls --color uses, if available
	export LS_COLORS="\
di=38;5;${MISCELLANEOUS_FOREGROUND};48;5;${MISCELLANEOUS_BACKGROUND}:\
ex=38;5;${HIGHLIGHT_FOREGROUND};48;5;${HIGHLIGHT_BACKGROUND}:\
ln=04:\
su=38;5;${ERROR2_FOREGROUND};48;5;${ERROR2_BACKGROUND}:\
sg=38;5;${ERROR2_FOREGROUND};48;5;${ERROR2_BACKGROUND}:\
"
fi

# ------------------------------------------------------------------------------
# - prompt_(environmental_variables)                                           -
# ------------------------------------------------------------------------------
#
# If root, the prompt should be a red pound sign.
# Otherwise, "$ " with highlight from theme

if [ $(tput colors) -eq "256" ] && [ -r ~/.themes/current/terminal/256-theme ]
then
	if [ $EUID -eq "0" ]
	then
		export PROMPT="%F{$ERROR_FOREGROUND}%K{$ERROR_BACKGROUND}#%f%k "
	elif [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]
	then
		export PROMPT="%F{$MISCELLANEOUS_FOREGROUND}%K{$MISCELLANEOUS_BACKGROUND}$%f%k "
	else
		export PROMPT="%F{$HIGHLIGHT_FOREGROUND}%K{$HIGHLIGHT_BACKGROUND}$%f%k "
	fi
fi

# ==============================================================================
# = completion                                                                 =
# ==============================================================================

# $fpath defines where Zsh searches for completion functions.  Include one in
# the $HOME directory for non-root-user-made completion functions.
#fpath=(~/.zsh/completion $fpath)

# Zsh's completion can benefit from caching.  Set the directory in which to
# load/store the caches.
CACHEDIR="$HOME/.zsh/$(uname -n)"
# If on Bedrock Linux, separate out caches by client.
if which brw 1>/dev/null 2>/dev/null
then
	CACHEDIR="$CACHEDIR-$(brw)"
fi
# Create  $CACHEDIR if it does not exist.
if [ ! -d $CACHEDIR ]; then
	mkdir -p $CACHEDIR
fi

# Use completion functionality.
autoload -U compinit
compinit -d $CACHEDIR/zcompdump 2>/dev/null

# Use cache to speed completion up.
zstyle ':completion:*' use-cache on

# Do not require running "rehash" manually
zstyle ':completion:*' rehash true

# Set the cache location.
zstyle ':completion:*' cache-path $CACHEDIR/cache

# If the <tab> key is pressed with multiple possible options, print the
# options.  If the options are printed, begin cycling through them.
zstyle ':completion:*' menu select

# Print the categories the completion options fit into.
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'

# Set format for warnings
zstyle ':completion:*:warnings' format 'No matches for: %d%b'

# Use colors when outputting file names for completion options.
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Do not prompt to cd into current directory.
# For example, cd ../<tab> should not prompt current directory.
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# When using history-complete-(newer/older), complete with the first item on
# the first request (as opposed to 'menu select' which only shows the menu on
# the first request)
zstyle ':completion:history-words:*' menu yes

# Have zsh treat "mosh" like "ssh"
compdef mosh=ssh

# ==============================================================================
# = functions_and_zle_widgets                                                  =
# ==============================================================================
#
# ------------------------------------------------------------------------------
# - zle_widgets                                                                -
# ------------------------------------------------------------------------------
#
# The ZLE widges are all followed by "zle -<MODE> <NAME>" and bound below in
# the "Key Bindings" section.

# Prepend "sudo" to the command line if it is not already there.
prepend-sudo() {
	if ! echo "$BUFFER" | grep -q "^sudo "
	then
		BUFFER="sudo $BUFFER"
		CURSOR+=5
	fi
}
zle -N prepend-sudo

# Prepend "vim" to the command line if it is not already there.
prepend-vim() {
	if ! echo "$BUFFER" | grep -q "^vim "
	then
		BUFFER="vim $BUFFER"
		CURSOR+=5
	fi
}
zle -N prepend-vim

# Delete all characters between a pair of characters.  Mimics Vim's "di" text
# object functionality.
delete-in() {
	# Create locally-scoped variables we'll need
	local CHAR LCHAR RCHAR LSEARCH RSEARCH COUNT
	# Read the character to indicate which text object we're deleting.
	read -k CHAR
	if [ "$CHAR" = "w" ]
	then # diw, delete the word.
		# find the beginning of the word under the cursor
		zle vi-backward-word
		# set the left side of the delete region at this point
		LSEARCH=$CURSOR
		# find the end of the word under the cursor
		zle vi-forward-word
		# set the right side of the delete region at this point
		RSEARCH=$CURSOR
		# Set the BUFFER to everything except the word we are removing.
		RBUFFER="$BUFFER[$RSEARCH+1,${#BUFFER}]"
		LBUFFER="$LBUFFER[1,$LSEARCH]"
		return
	# diw was unique.  For everything else, we just have to define the
	# characters to the left and right of the cursor to be removed
	elif [ "$CHAR" = "(" ] || [ "$CHAR" = ")" ] || [ "$CHAR" = "b" ]
	then # di), delete inside of a pair of parenthesis
		LCHAR="("
		RCHAR=")"
	elif [ "$CHAR" = "[" ] || [ "$CHAR" = "]" ]
	then # di], delete inside of a pair of square brackets
		LCHAR="["
		RCHAR="]"
	elif [ $CHAR = "{" ] || [ $CHAR = "}" ] || [ "$CHAR" = "B" ]
	then # di], delete inside of a pair of braces
		LCHAR="{"
		RCHAR="}"
	else
		# The character entered does not have a special definition.
		# Simply find the first instance to the left and right of the
		# cursor.
		LCHAR="$CHAR"
		RCHAR="$CHAR"
	fi
	# Find the first instance of LCHAR to the left of the cursor and the
	# first instance of RCHAR to the right of the cursor, and remove
	# everything in between.
	# Begin the search for the left-sided character directly the left of the cursor.
	LSEARCH=${#LBUFFER}
	# Keep going left until we find the character or hit the beginning of the buffer.
	while [ "$LSEARCH" -gt 0 ] && [ "$LBUFFER[$LSEARCH]" != "$LCHAR" ]
	do
		LSEARCH=$(expr $LSEARCH - 1)
	done
	# If we hit the beginning of the command line without finding the character, abort.
	if [ "$LBUFFER[$LSEARCH]" != "$LCHAR" ]
	then
		return
	fi
	# start the search directly to the right of the cursor
	RSEARCH=0
	# Keep going right until we find the character or hit the end of the buffer.
	while [ "$RSEARCH" -lt $(expr ${#RBUFFER} + 1 ) ] && [ "$RBUFFER[$RSEARCH]" != "$RCHAR" ]
	do
		RSEARCH=$(expr $RSEARCH + 1)
	done
	# If we hit the end of the command line without finding the character, abort.
	if [ "$RBUFFER[$RSEARCH]" != "$RCHAR" ]
	then
		return
	fi
	# Set the BUFFER to everything except the text we are removing.
	RBUFFER="$RBUFFER[$RSEARCH,${#RBUFFER}]"
	LBUFFER="$LBUFFER[1,$LSEARCH]"
}
zle -N delete-in


# Delete all characters between a pair of characters and then go to insert mode.
# Mimics Vim's "ci" text object functionality.
change-in() {
	zle delete-in
	zle vi-insert
}
zle -N change-in

# Delete all characters between a pair of characters as well as the surrounding
# characters themselves.  Mimics Vim's "da" text object functionality.
delete-around() {
	zle delete-in
	zle vi-backward-char
	zle vi-delete-char
	zle vi-delete-char
}
zle -N delete-around

# Delete all characters between a pair of characters as well as the surrounding
# characters themselves and then go into insert mode  Mimics Vim's "ca" text
# object functionality.
change-around() {
	zle delete-in
	zle vi-backward-char
	zle vi-delete-char
	zle vi-delete-char
	zle vi-insert
}
zle -N change-around

# Increment the number under the cursor, or find the next number to the right
# of the cursor and increment that number.  Emulate vim's ctrl-a functionality.
# This code is not my style at all; presumably I found it somewhere online, but
# I no longer remember the source to cite or credit.
increment-number() {
	emulate -L zsh
	setopt extendedglob
	local pos num newnum sign buf
	if [[ $BUFFER[$((CURSOR + 1))] = [0-9] ]]; then
		pos=$((${#LBUFFER%%[0-9]##} + 1))
	else
		pos=$(($CURSOR + ${#RBUFFER%%[0-9]*} + 1))
	fi
	(($pos <= ${#BUFFER})) || return
	num=${${BUFFER[$pos,-1]}%%[^0-9]*}
	if ((pos > 0)) && [[ $BUFFER[$((pos - 1))] = '-' ]]; then
		num=$((0 - num))
		((pos--))
	fi
	newnum=$((num + ${NUMERIC:-${incarg:-1}}))
	if ((pos > 1)); then
		buf=${BUFFER[0,$((pos - 1))]}${BUFFER[$pos,-1]/$num/$newnum}
	else
		buf=${BUFFER/$num/$newnum}
	fi
	BUFFER=$buf
	CURSOR=$((pos + $#newnum - 2))
}
zle -N increment-number

# Decrement the number under the cursor, or find the next number to the right
# of the cursor and increment that number.  Emulate vim's ctrl-x functionality.
# This code is not my style at all; presumably I found it somewhere online, but
# I no longer remember the source to cite or credit.
decrement-number() {
	emulate -L zsh
	setopt extendedglob
	local pos num newnum sign buf
	if [[ $BUFFER[$((CURSOR + 1))] = [0-9] ]]; then
		pos=$((${#LBUFFER%%[0-9]##} + 1))
	else
		pos=$(($CURSOR + ${#RBUFFER%%[0-9]*} + 1))
	fi
	(($pos <= ${#BUFFER})) || return
	num=${${BUFFER[$pos,-1]}%%[^0-9]*}
	if ((pos > 0)) && [[ $BUFFER[$((pos - 1))] = '-' ]]; then
		num=$((0 - num))
		((pos--))
	fi
	newnum=$((num - ${NUMERIC:-${incarg:-1}}))
	if ((pos > 1)); then
		buf=${BUFFER[0,$((pos - 1))]}${BUFFER[$pos,-1]/$num/$newnum}
	else
		buf=${BUFFER/$num/$newnum}
	fi
	BUFFER=$buf
	CURSOR=$((pos + $#newnum - 2))
}
zle -N decrement-number

# Zsh's history-beginning-search-backward is very close to Vim's
# i_ctrl-x_ctrl-l; however, with Vim, it leaves you in insert mode with the
# cursor at the end of the line.  Surprisingly, there was nothing closer to Vim
# in Zsh by default.  This creates something closer to Vim's i_ctrl-x_ctrl-l.
history-beginning-search-backward-then-append() {
	zle history-beginning-search-backward
	zle vi-add-eol
}
zle -N history-beginning-search-backward-then-append

# ------------------------------------------------------------------------------
# - non-zle_widget_functions                                                   -
# ------------------------------------------------------------------------------

# go _d_own to the specified directory name
d() {
	target=$(find . -type d -name "$1" -print -quit 2>/dev/null)
	if [ "x$target" != "x" ]
	then
		cd $target
	fi
	pwd
}

# go _u_p to the specified directory OR number of levels if it is a number
u() {
	if [ -z "$1" ]
	then
		cd ..
	elif [ "$1" = "/" ]
	then
		cd /
	elif echo "$1" | grep -q '[0-9]\+'
	then
		cd "$(pwd | awk 'BEGIN{FS=OFS="/"}NF>'"$1"'{NF-='"$1"'}NF==1{print"/"}NF>1')"
	else
		cd "$(pwd | awk 'BEGIN{FS=OFS="/"}{for(i=NF;i>1;i--){if($i ~ "'"$1"'"){NF=i;break}}}1')"
	fi
	pwd
}

# go to directory from dir _h_istory
# If no argument is given, prints cwd history.
# This first looks for a match at the deepest level in the directory for every
# item in the history, then works its way up the tree.
h() {
	# if no argument is specified, list the history
	if [ -z "$1" ]
	then
		dirs -lp
		return
	fi
	if [ "$1" = "/" ]
	then
		cd /
		return
	fi
	target="$(dirs -lp | awk '
	BEGIN {
		FS=OFS="/"
	}
	{
		if(NF>nfmax)
			nfmax=NF;
		rs[NR] = $0
	}
	END{
		for(i=0;i<nfmax;i++) {
			for(j=1;j<=NR;j++) {
				$0=rs[j]
				if (NF>=i && $(NF-i) ~ "'"$1"'") {
					NF-=i
					print $0
					i=nfmax+1
					j=NR+1
				}
			}
		}
	}
	')"
	if [ "x$target" != "x" ]
	then
		cd "$target"
	fi
	pwd
}

# save directory for later reference
m() {
	if [ -z "$1" ]
	then
		mark="$(basename $(pwd))"
	else
		mark="$1"
	fi
	echo "$mark $(pwd) >> $SHELLDIR/dirmarks"
	echo "$mark $(pwd)" >> "$SHELLDIR/dirmarks"
}

# go to directory saved by m()
f() {
	cd $(awk 'BEGIN{x="'"$(pwd)"'"}$1 ~ '/"$1"'/{$1="";x=$0}END{print x}' $SHELLDIR/dirmarks)
	pwd
}

# print a field from the output of the last command
# useful for acting on the output of the last command, e.g.:
# $ alias -g Z='$(field_from_last_command'
# $ grep -RH "error"
# ./README.md:ignore errors
# ./exceptions.py:# error
# $ vim Z 2 :)
# -> now editing exceptions.py
field_from_last_command(){
	if [ "$#" -eq 0 ]
	then
		fc -l -1 | tr -s " " | cut -d" " -f3-
	elif [ "$#" -eq 1 ]
	then
		eval $(fc -l -1 | tr -s " " | cut -d" " -f3-) | sed -n "$1p"
	elif [ "$#" -eq 2 ]
	then
		eval $(fc -l -1 | tr -s " " | cut -d" " -f3-) | awk "NR==$1{print\$$2;exit}"
	elif [ "$#" -eq 3 ]
	then
		eval $(fc -l -1 | tr -s " " | cut -d" " -f3-) | awk -F"$3" "NR==$1{print\$$2;exit}"
	fi
}

# ==============================================================================
# = key_bindings                                                               =
# ==============================================================================
#
# My goal here is to make the ZLE feel as much like Vim as possible without
# losing any useful functionality.

# Use vi-style keybindings
bindkey -v

# Remove escape timeout in insert mode
bindkey -rpM viins '^['

# Remove escape timeout in normal mode
bindkey -rpM vicmd '^['

# ------------------------------------------------------------------------------
# - insert_mode_(key bindings)                                                 -
# ------------------------------------------------------------------------------

# Have i_backspace work as it does in Vim.
bindkey -M viins "^?" backward-delete-char

# Have i_ctrl-a work as it does in Vim.
bindkey -M viins "^A" beginning-of-line

# Have i_ctrl-p work as c_ctrl-p does in Vim.
bindkey -M viins "^P" up-line-or-history

# Have i_ctrl-e work as it does in Vim.
bindkey -M viins "^E" end-of-line

# Have i_ctrl-n work as c_ctrl-n does in Vim.
bindkey -M viins "^N" down-line-or-history

# Have i_ctrl-h work as it does in Vim.
bindkey -M viins "^H" backward-delete-char

# Have i_ctrl-b work as i_ctrl-p does in Vim.
bindkey -M viins "^B" _history-complete-newer

# Have i_ctrl-f work as i_ctrl-n does in Vim.
bindkey -M viins "^F" _history-complete-older

# Prepend "sudo ".  This does not have a Vim parallel.
bindkey "^S" prepend-sudo

# Prepend "vim ".  This does not have a Vim parallel.
bindkey "^V" prepend-vim

# Have i_ctrl-u work as it does in Vim.
bindkey -M viins "^U" backward-kill-line

# Have i_ctrl-w work as it does in Vim.
bindkey -M viins "^W" backward-kill-word

# Have i_ctrl-x_i_ctrl-l work as it does in Vim.
bindkey -M viins "^X^L" history-beginning-search-backward-then-append

# Display _completion_help for creating completion functions.  This does not
# have a Vim parallel.
bindkey -M viins "^X^H" _complete_help

# attempt to complete line based on history, roughly as i_ctrl-x_ctrl-l does in
# Vim.
bindkey -M viins "^X^L" history-incremental-search-backward

# Cut the contents of the line and paste immediately when the next prompt
# appears.  This does not have a clean Vim parallel.
bindkey -M viins "^Y" push-line

# ------------------------------------------------------------------------------
# - normal_mode_(key_bindings)                                                 -
# ------------------------------------------------------------------------------

# Have ctrl-a work as it does in Vim.
bindkey -M vicmd "^A" increment-number

# Mimics Vim's "ca" text object functionality.
bindkey -M vicmd "ca" change-around

# Mimics Vim's "ci" text object functionality.
bindkey -M vicmd "ci" change-in

# If not explicitly set, above ca/ci bindings will cause a delay
bindkey -M vicmd "cc" vi-change-whole-line

# Mimic Vim's da text-object functionality.
bindkey -M vicmd "da" delete-around

# Mimic Vim's di text-object functionality.
bindkey -M vicmd "di" delete-in
#
# If not explicitly set, above da/di bindings will cause a delay
bindkey -M vicmd "dd" kill-whole-line

# Have ctrl-e work as it does in Vim.
bindkey -M vicmd "^E" vi-add-eol

# Have g~ work as it does in Vim.
bindkey -M vicmd "g~" vi-oper-swap-case

# Have ga work as it does in Vim.
bindkey -M vicmd "ga" what-cursor-position

# Have gg work as it does in Vim.
bindkey -M vicmd "gg" beginning-of-history

# Have G work as it does in Vim.
bindkey -M vicmd "G" end-of-history

# Have ctrl-r work as it does in Vim.
bindkey -M vicmd "^R" redo

# Editing the line in Vim proper.
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd "^V" edit-command-line
bindkey -M vicmd v edit-command-line

# Have ctrl-a work as it does in Vim.
bindkey -M vicmd "^X" decrement-number

# ==============================================================================
# = aliases                                                                    =
# ==============================================================================

# ------------------------------------------------------------------------------
# - new_commands_(aliases)                                                     -
# ------------------------------------------------------------------------------

# Clear the screen then run `ls`
alias cls="clear;ls"

# Search entire filesystem and ignore errors
alias finds="find / -name 2>/dev/null"

# Take ownership of file or directory
alias mine="sudo chown -R $(whoami):$(whoami)"

# allow others to read/execute
alias yours="sudo find . -perm -u+x -exec chmod a+x {} \; && sudo find . -perm -u+r -exec chmod a+r {} \;"

# Resume work on a TeX project
alias rtex="uxterm -e texautofollow& mupdf -V *.pdf& vim --servername "tex" *.tex"

# ------------------------------------------------------------------------------
# - shortcuts_to_existing_commands_(aliases)                                   -
# ------------------------------------------------------------------------------

alias :q="exit"
alias :wq="exit"
alias s="sudo"
alias sd="sudo poweroff"
alias sr="sudo reboot"
alias ss="sudo pm-suspend"
alias sx="startx& exit"
alias ta="tmux attach"
alias v="vim"
alias vs="vim --servername vim"
alias vv="cd /dev/shm/"

# ------------------------------------------------------------------------------
# - set_default_flags_(aliases)                                                -
# ------------------------------------------------------------------------------

alias 2pdf="libreoffice --headless --invisible --convert-to pdf"
alias cl="cclive --format=best"
alias df="df -h"
alias du="du -hs"
alias greps="grep -IR --color=yes -D skip --exclude-dir=.git"
alias la="ls -A --color=auto -h --group-directories-first"
alias ll="ls -lA --color=auto -h  --group-directories-first"
alias ls="ls --color=auto -h  --group-directories-first"
alias octave="octave --silent"
alias xpdfr="xpdf -remote 127.0.0.1"
alias xpdfv="xpdf -rv"
alias pw="pal -r 7"
alias pm="pal -r 31"
if [ -r ~/.mozilla/firefox/profiles.ini ]
then
	for profile in $(awk -F= '/^Name=/{print$2}' ~/.mozilla/firefox/profiles.ini)
	do
		alias fx-$profile="firefox -P $profile -no-remote"
	done
fi

# ------------------------------------------------------------------------------
# - git_(aliases)                                                              -
# ------------------------------------------------------------------------------

alias gg="git grep --color"
alias ga="git add"
alias gc="git commit -v"
alias gcd="git commit -a -v -m \"\$(date)\""
alias gb="git branch"
alias gl="git log --graph --color"
alias gr="git reset --hard HEAD"
alias gs="git status"
alias gw="git show"
alias gco="git checkout"
alias gm="git merge"
alias gus="git push"
alias guss='git push origin $(git branch | awk '\''/^\*/{print$2}'\'')'
alias gul="git pull"
alias gull='git pull origin $(git branch | awk '\''/^\*/{print$2}'\'')'
alias gusu='git submodule foreach git pull origin master'
alias gdh='git diff HEAD'
alias gt="git rev-parse --show-toplevel"

# ------------------------------------------------------------------------------
# - bedrock_clients_(aliases)                                                  -
# ------------------------------------------------------------------------------

if which brc 1>/dev/null 2>/dev/null
then
	for CLIENT in $(bri -l)
	do
		alias $CLIENT="brc $CLIENT"
		alias s$CLIENT="sudo brc $CLIENT"
	done
fi

# ------------------------------------------------------------------------------
# - package_management_(aliases)                                               -
# ------------------------------------------------------------------------------

if [ -f /etc/arch-release ]
then
	DISTRO="Arch"
elif [ -f /etc/slackware-version ]
then
	DISTRO="Slackware"
elif [ -f /etc/gentoo-release ]
then
	DISTRO="Gentoo"
elif [ -f /etc/debian-release ]
then
	DISTRO="Debian"
elif [ -d /etc/linuxmint ]
then
	DISTRO="Mint"
elif [ -f /etc/lsb-release ]
then
	DISTRO=$(awk -F= '/DISTRIB_ID/{print$2;exit}' /etc/lsb-release)
elif [ -f /etc/issue ]
then
	DISTRO=$(awk '/[:alpha:]/{print$1;exit}' /etc/issue 2>/dev/null)
fi

if [ "$DISTRO" = "Debian" ] || [ "$DISTRO" = "Ubuntu" ] || [ "$DISTRO" = "Mint" ]
then
	# Install package
	alias ki="sudo apt-get install"
	# Remove package
	alias kr="sudo apt-get --purge remove"
	# Updated packages
	alias ku="sudo apt-get update && sudo apt-get upgrade"
	# List installed packages
	alias kl="dpkg -l"
	# Clean up package manager cruft
	alias kc="sudo apt-get --purge autoremove"
	# Search for package name in repository
	alias ks="apt-cache search"
	# show to which installed package a file Belongs
	alias kb="dpkg -S"
	# shoW information about package
	alias kw="apt-cache show"
	# Find package containing file
	alias kf="apt-file search"
	# install package containing file
	kfi(){
		results=$(apt-file search $1 | grep "$1$")
		count=$(echo $results | wc -l)
		if [ $cout -eq 1 ]
		then
			sudo apt-get install $(echo results | awk '{print$1}')
		else
			echo $results
		fi
	}
	# install search result
	ksi(){
		results=$(apt-cache search $1 | grep "$1$")
		count=$(echo $results | wc -l)
		if [ $cout -eq 1 ]
		then
			sudo apt-get install $(echo results | awk '{print$1}')
		else
			echo $results
		fi
	}
elif [ "$DISTRO" = "Arch" ]
then
	if which packer >/dev/null
	then
		# Install package
		alias ki="sudo packer -S"
		# Remove package
		alias kr="sudo pacman -R" # packer does not provide -R
		# Updated packages
		alias ku="sudo packer -Syu"
		# List installed packages
		alias kl="pacman -Q" # packer does not provide -Q
		# Clean up package manager cruft
		alias kc='sudo packer -Sc && for PKG in `packer -Qqtd`; do sudo packer -Rs $PKG; done'
		# Search for package name in repository
		alias ks="packer -Ss"
		# show to which installed package a file Belongs
		alias kb="pacman -Qo"
		# shoW information about package
		alias kw="packer -Si"
		# Find package containing file
		alias kf="sudo pkgfile"
	else
		# Install package
		alias ki="sudo pacman -S"
		# Remove package
		alias kr="sudo pacman -R"
		# Updated packages
		alias ku="sudo pacman -Syu"
		# List installed packages
		alias kl="pacman -Q"
		# Clean up package manager cruft
		alias kc='sudo pacman -Sc && for PKG in `pacman -Qqtd`; do sudo pacman -Rs $PKG; done'
		# Search for package name in repository
		alias ks="pacman -Ss"
		# show to which installed package a file Belongs
		alias kb="pacman -Qo"
		# shoW information about package
		alias kw="pacman -Si"
		# Find package containing file
		alias kf="sudo pkgfile"
	fi
elif [ "$DISTRO" = "Fedora" ]
then
	# Install package
	alias ki="sudo yum install"
	# Remove package
	alias kr="sudo yum remove"
	# Updated packages
	alias ku="sudo yum update"
	# List installed packages
	alias kl="yum list installed"
	# Clean up package manager cruft
	alias kc="sudo yum clean all"
	# Search for package name in repository
	alias ks="yum search"
	# show to which installed package a file Belongs
	alias kb="rpm -qa"
	# shoW information about package
	alias kw="yum info"
	# Find package containing file
	alias kf="sudo yum whatprovides"
elif [ "$DISTRO" = "Slackware" ]
then
	# Install package
	alias ki="sudo slackpkg install"
	# Remove package
	alias kr="sudo slackpkg remove"
	# Updated packages
	alias ku="sudo slackpkg update && slackpkg install-new && slackpkg upgrade-all"
	# Search for package name in repository
	alias ks="sudo slackpkg search"
elif [ "$DISTRO" = "Gentoo" ]
then # none of these are tested, just gathered around
	# Install package
	alias ki="emerge"
	# Remove package
	alias kr="emerge -C"
	# List installed package
	alias kl="emerge -ep world"
	# Clean up package manager cruft
	alias kc="emerge --depclean"
	# Search for package name in repository
	alias ks="emerge --search"
	# show to which installed package a file Belongs
	alias kb="equery belongs"
	# Updated packages
	alias ku="emerge --update --ask world"
	alias kU="emerge --update --deep --newuse world"
	# shoW information about package
	alias kS="emerge --searchdesc"
fi

# ------------------------------------------------------------------------------
# - global_(aliases)                                                           -
# ------------------------------------------------------------------------------

alias -g L="|less"
alias -g G="|grep"
alias -g B="&exit"
alias -g H="|head"
alias -g T="|tail"
alias -g C="|column -t"
alias -g V="|vim -m -c 'set nomod' -"
alias -g Q=">/dev/null 2>&1"
alias -g Z='$(field_from_last_command'

# ------------------------------------------------------------------------------
# - suffix_(aliases)                                                           -
# ------------------------------------------------------------------------------

alias -s html=$BROWSER
alias -s htm=$BROWSER
alias -s org=$BROWSER
alias -s php=$BROWSER
alias -s com=$BROWSER
alias -s edu=$BROWSER
alias -s txt=$EDITOR
alias -s tex=$EDITOR
alias -s pdf=$PDFREADER
alias -s gz=tar -xzvf
alias -s bz2=tar -xjvf

# ------------------------------------------------------------------------------
# -  disable_corrrectall_in_these_situations                                   -
# ------------------------------------------------------------------------------

alias mkdir="nocorrect mkdir"
alias cp="nocorrect cp"
alias mv="nocorrect mv"
alias ln="nocorrect ln"

# ==============================================================================
# = run_tmux                                                                   =
# ==============================================================================
#
# if we're on a remote machine and tmux is running ensure we're in tmux

if [ -n "$SSH_CLIENT" ] ||\
	[ -n "$SSH_TTY" ] &&\
	[ -z "$TMUX" ] &&\
	ps -u $(id -u) -o cmd | grep -q "^tmux$"
then
	exec tmux attach -d
fi

# ==============================================================================
# = runit                                                                      =
# ==============================================================================
#
# If runit is set up for a user session but not running, launch it.

export SVDIR="$HOME/.sv"
if ! ps -u $(id -u) -o cmd | grep -v grep | grep -qF "runsvdir $SVDIR"
then
	printf "Starting runsvdir: "
	runsvdir $SVDIR &
fi
svall() {
	if [ -z "$1" ]
	then
		cmd="status"
	else
		cmd="$1"
	fi
	sv $cmd $SVDIR/*
}
