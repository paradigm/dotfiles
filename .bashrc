# ==============================================================================
# = paradigm's_.bashrc                                                         =
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
[ -z "$PS1" ] && return

# Disable history.
export HISTFILE=

# Update $LINES and $COLUMNS when terminal size changes.
shopt -s checkwinsize

# Enable extended globbing functionality.
shopt -s extglob

# Disable flow control.  Specifically, ensure that ctrl-s does not stop
# terminal flow so that it can be used in other programs (such as Vim).
stty -ixon

# ==============================================================================
# = functions                                                                  =
# ==============================================================================

# implement zsh's autopushd
cd() {
	if [ -z "$1" ]
	then
		dir=$HOME
	else
		dir="$1"
	fi
	builtin pushd "${dir}">/dev/null
}


# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
# ~ cd family                                                                  ~
# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 

# This is a family of functions for improved navigation the filesystem,
# superseding `cd` in specific situations.
#
# d(), u() and h() all take an argument which should be a substring of the
# desired filepath.  To anchor the substring to the start or the end of the
# target directory name, put a "/" on the desired anchor point.  Also supports
# using "/" as part of the substring to specify a parent directory.
#
# d() searches _d_ownward for the specified directory.  It returns the match
# closest to the pwd (i.e. does a depth-first search).
#
# u() searches _u_pward for the specified directory.  It returns the match
# closest to the pwd (i.e. the deepest directory which matches).
# Alternatively, it could take a number which indicates the number of
# directories to go up.
#
# h() searches the directory stack for the specified directory.  It returns the
# match closest to a previous pwd that is the most recent.  This is most useful
# when paired with zsh's autopushd or equivalent.
#
# t() _t_ags the current pwd into a list of tagged directories.  The first
# argument specifies the desired tag name.  If no argument is used, it defaults
# to the basename.
#
# r() _r_estores the pwd to the most recent match from the tagged directories.
# Can use "/" as anchors for consistency with d(), u() and h().  No argument
# dumps the tagged directory list.
#
# Careful with special characters; globbing and regex are used under-the-hood.

d() {
	# no arg, don't do anything
	[ -z "$1" ] && pwd && return

	# get argument for `find`
	# -> last directory with "*" set for globbing on non-anchored sides
	findarg="$(echo "$1" | awk -F/ 'BEGIN{l="*";r="*"}$NF==""{NF--;r=""}{x=$NF}NF>1{l=""}END{print l""x""r}')"
	# get argument for `grep`
	# -> replace right anchor with "$"
	greparg="$(echo "$1" | sed 's/\/$/$/')"
	# starting and ending depth.  Gives up after maxdepth.
	depth=1
	maxdepth=10

	# Find target directory.
	#
	# If there's no "/" other than trailing anchor and GNU find is available,
	# use slightly faster version.
	if ! echo "$greparg" | grep -q "/" && find --version | grep -q "GNU"
	then
		target="$(
		while [ "$depth" != "$maxdepth" ] && ! find -mindepth $depth -maxdepth $depth -type d -name "$findarg" -print -quit 2>/dev/null | grep "."
		do
			((depth++))
		done
		)"
	else
		# slightly slower version due to non-trailing-anchor "/" or find without -quit
		target="$(
		while [ "$depth" != "$maxdepth" ] && ! find -mindepth $depth -maxdepth $depth -type d -name "$findarg" -print 2>/dev/null | grep "$greparg"
		do
			((depth++))
		done | head -n1
		)"
	fi
	depth=1
	maxdepth=10 # max depth to search before giving up
	[ "x$target" != "x" ] && cd "$target"
	pwd
}

u() {
	if [ -z "$1" ]
	then
		# no argument, just act like `cd ..`
		cd ..
	elif [ "$1" = "/" ]
	then
		# This is fairly meaningless in normal context.  Treat as `cd /`
		cd /
	elif echo "$1" | grep -q '[0-9]\+'
	then
		# `cd ..` the specified number of directories
		cd "$(pwd | awk 'BEGIN{FS=OFS="/"}NF>'"$1"'{NF-='"$1"'}NF==1{print"/"}NF>1')"
	else
		# Go to matching parent directory
		p="$(pwd)/"
		if echo "$1" | grep -q "/$"
		then
			# Ends in a slash, anchor right.  Just cut out the fields we don't want.
			cd "${p%"$1"*}$1"
		else
			# Does not end in a slash, we need to expand the last directory.
			# Use parameter expansion to cut out the part we don't want, then
			# count the number of fields that exist with the remaining part.
			fields=$(echo ${p%"$1"*}$1 | awk -F/ '{print NF}')
			# Have awk simply print the desired number of fields
			cd $(pwd | awk -F/ 'BEGIN{IFS=OFS="/"}{NF='$fields'}1')
		fi
	fi
	pwd
}

h() {
	if [ -z "$1" ]
	then
	# if no argument is specified, list the history
		dirs -l -p
		return
	fi
	if [ "$1" = "/" ]
	then
		# This is fairly meaningless in normal context.  Treat as `cd /`
		cd /
		return
	fi

	# iterate over lines in history
	# append a "/" so the trailing anchor will match
	target="$(dirs -l -p | sed 's/$/\//' | awk -v"pat=$1" '
	BEGIN {
		OFS=FS="/"
		# due to how awk fields work, at one point we do not want to consider
		# trailing slash in pattern
		if (pat ~ "/$") {
			patx = substr(pat,1,length(pat)-1)
		} else {
			patx = pat
		}
	}
	$0 ~ pat {
		# strip away all the fields from the left that we can without breaking
		# the pattern to ensure we have the right-most match.
		line=$0
		while ($0 ~ pat) {
			pre_last=$0
			# strip field from left
			$0=substr($0,2)
			$1=""
		}
		# strip away fields from the right to count how far from pwd the match
		# is
		$0=pre_last
		rank=0
		while ($0 ~ patx) {
			NF--;
			rank++;
		}
		# compare to current best
		if (rank > bestrank) {
			$0 = line
			NF -= rank-1
			bestrank = rank
			bestline = $0
		}
	}
	END {
		print bestline
	}
	')"
	[ "x$target" != "x" ] && cd "$target"
	pwd
}

t() {
	if [ -z "$1" ]
	then
		# if no argument is specified, use base name as tag
		tag="$(basename $(pwd))"
	else
		tag="$1"
	fi
	echo "$tag $(pwd) >> ~/.dirtags"
	echo "$tag $(pwd)" >> ~/.dirtags
}

r() {
	if [ -z "$1" ]
	then
		# if no argument is specified, dump tags
		column -t ~/.dirtags
		return
	fi
	pat="$(echo "$1" | sed 's/\/$/$/' | sed 's/^\//^/')"
	target="$(awk -v"pat=$pat" '$1 ~ pat{$1="";print substr($0,2);exit}' ~/.dirtags)"
	[ "x$target" != "x" ] && cd "$target"
	pwd
}

# ==============================================================================
# = key_bindings                                                               =
# ==============================================================================
#
# Note that bash uses readline, and thus further bindings can be placed in
# ~/.inputrc

# Use vi-like insert/normal mode functionality at the command line.
# Bash's vi-mode is not sufficiently extendable, so this remains disabled.
#set -o vi

# By default, ctrl-w will delete the word before the cursor.  However, this
# considers "/" a word-character which makes fixing typos in filesystem paths a
# pain.  Meta-backspace acts as desired, but doesn't fit my muscle memory.
# This is a work around to make ctrl-w work like meta-backspace.
bind '"":""'

# ==============================================================================
# = environmental_variables                                                    =
# ==============================================================================
#
# ------------------------------------------------------------------------------
# - general_(environmental_variables)                                          -
# ------------------------------------------------------------------------------

# "/bin/bash" should be the value of $SHELL if this config is parsed.  This
# line should not be necessary, but it's not a bad idea to have just in case.
export SHELL="/bin/bash"

# Set pagers
if which vim >/dev/null 2>&1
then
	export MANPAGER="sh -c \"unset MANPAGER; col -b -x | vim --cmd 'set modelines=0' -c 'set filetype=man nomod nolist foldlevel=999' -\""
	export GIT_PAGER="vim --cmd 'set modelines=0' -c 'set filetype=git nomod nolist foldlevel=999' -"
fi

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

#if [ "$(id -u)" -eq "0" ]
if [ $(tput colors) -eq "256" ] && [ -r ~/.themes/current/terminal/256-theme ]
then
 	if [ $EUID -eq "0" ]
 	then
		export PS1="\[\e[38;5;${ERROR_FOREGROUND}m\e[48;5;${ERROR_BACKGROUND}m#\e[0m\]\] "
 	elif [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]
 	then
		export PS1="\[\e[38;5;${MISCELLANEOUS_FOREGROUND}m\e[48;5;${MISCELLANEOUS_BACKGROUND}m$\e[0m\]\] "
 	else
		export PS1="\[\e[38;5;${HIGHLIGHT_FOREGROUND}m\e[48;5;${HIGHLIGHT_BACKGROUND}m$\e[0m\]\] "
 	fi
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

alias ..="cd .."
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
alias vv="cd /dev/shm"
alias Z="field_from_last_command"

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

alias ga="git add"
alias gc="git commit -v"
alias gcd="git commit -a -v -m \"\$(date)\""
alias gb="git branch"
alias gl="git log"
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
alias gT='cd "$(git rev-parse --show-toplevel)"'

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
