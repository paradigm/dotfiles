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
# catagories used below.

# The default permissions on newly-created files will not be readable,
# writable, or executable by anyone other than the owner of the file. 
umask 077

# None of the lines following this point are useful for non-interactive
# instances of this shell.  If the $PS1 variable does not exist, this instances
# of the shell is non-interactive, so exit the rc file.
# TODO: This is known to work in bash, needs confirmation it works in zsh.
[ -z "$PS1" ] && return

# If non-ambiguous, allow changing into a directory just by typing its name
# (ie, make "cd" optional)
setopt autocd

# Detect and prompt to correct typos in commands.
# Note there is a "correctall" varient which also prompts to correct arguments
# to commands, but this ends up being more troublesome than useful.
setopt correct

# When offering typo corrections, do not propose anything which starts with an
# underscore (such as many of Zsh's shell functions).
CORRECT_IGNORE='_*'

# Enable extended globbing functionality.
setopt extendedglob

# Disables the beep Zsh would otherwise make when giving invalid input (such as
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

# Do not consider "/" a word character.  One benefit of this is that when
# hitting ctrl-w in insert mode (which deletes the word before the cursor) just
# before a filesystem path, it only removes the last item of the path and not
# the entire thing.
WORDCHARS=${WORDCHARS//\/}

# ==============================================================================
# = completion                                                                 =
# ==============================================================================

# $fpath defines where Zsh searches for completion functions.  Include one in
# the $HOME directory for non-root-user-made completion functions.

#fpath=(~/.zsh/completion $fpath)

# Zsh's completion can benefit from caching.  Set the directory in which to
# load/store the caches.
CACHEDIR="$HOME/.zsh/$(uname -n)"
# If on Bedrock, separate out caches by client.
if which brw >/dev/null
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

# Set the cache location.
zstyle ':completion:*' cache-path $CACHEDIR/cache

# If the <tab> key is pressed with multiple possible options, print the
# options.  If the options are printed, begin cycling through them.
zstyle ':completion:*' menu select

# Print the catagories the completion options fit into.
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'

# Set format for warnings
zstyle ':completion:*:warnings' format 'Sorry, no matches for: %d%b'

# Use colors when outputting file names for completion options.
zstyle ':completion:*' list-colors ''

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
	elif [ "$CHAR" = "(" ] || [ "$CHAR" = ")" ]
	then # di), delete inside of a pair of parenthesis
		LCHAR="("
		RCHAR=")"
	elif [ "$CHAR" = "[" ] || [ "$CHAR" = "]" ]
	then # di], delete inside of a pair of square brackets
		LCHAR="["
		RCHAR="]"
	elif [ $CHAR = "{" ] || [ $CHAR = "}" ]
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

# Change directory then immediately clear the screen and run `ls`.
cds() {
	cd $1 && clear && ls
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

# Mimic Vim's da text-object functionality.
bindkey -M vicmd "da" delete-around

# Mimic Vim's di text-object functionality.
bindkey -M vicmd "di" delete-in

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
# = environmental_variables                                                    =
# ==============================================================================
#
# ------------------------------------------------------------------------------
# - general_(evironmental_variables)                                           -
# ------------------------------------------------------------------------------

# "/bin/zsh" should be the value of $SHELL if this config is parsed.  This line
# should not be necessary, but it's not a bad idea to have just in case.
export SHELL="/bin/zsh"

# Set the default text editor.
export EDITOR="vim"

# Set the default web browser.
if [ -z "$DISPLAY" ]
then
	export BROWSER="elinks"
else
	if which dwb 1>/dev/null 2>/dev/null
	then
		export BROWSER="dwb"
	else
		export BROWSER="firefox"
	fi
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
export PDFREADER="mupdf"
export PDFVIEWER="mupdf"

# Set the default image viewer.
export IMAGEVIEWER="mupdf"

# Set Sage's PDF/DVI/PNG browser.  This goes to a shell script which will call
# the appropriate PDF viewer or image viewer.
export SAGE_BROWSER="sage_browser"

# sets mail directory
export MAIL="~/.mail"

# ------------------------------------------------------------------------------
# - prompt_(environmental_variables)                                           -
# ------------------------------------------------------------------------------
#
# If root, the prompt should be a red pound sign.
# Otherwise, it should be a blue dollar sign.

if [ $(id -u) -eq "0" ]
then
	export PROMPT=$'%{\e[0;30m\e[41m%}#%{\e[m%} '
elif [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]
then
	export PROMPT=$'%{\e[0;30m\e[46m%}$%{\e[m%} '
else
	export PROMPT=$'%{\e[0;30m\e[47m%}$%{\e[m%} '
fi

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
alias mpv="mupdf -V"

# ------------------------------------------------------------------------------
# - git_(aliases)                                                              -
# ------------------------------------------------------------------------------

alias gc="git commit -a -v"
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

# ------------------------------------------------------------------------------
# - bedrock_clients_(aliases)                                                  -
# ------------------------------------------------------------------------------

if which brc >/dev/null
then
	for CLIENT in $(bri -l)
	do
		alias $CLIENT="brc $CLIENT $SHELL"
		alias s$CLIENT="sudo brc $CLIENT $SHELL"
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
alias -g V="|vim -m -c 'set nomod' -"

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
	tmux attach -d
fi
