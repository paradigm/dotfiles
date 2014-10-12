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

# go _d_own to the specified directory name
# supports globbing
if find --version | grep -q GNU
then
	d() {
		target=$(find . -type d -name "$1" -print -quit 2>/dev/null)
		if [ "x$target" != "x" ]
		then
			cd $target
		fi
		pwd
	}
else
	d() {
		target=$(find . -type d -name "$1" -print 2>/dev/null | head -n1)
		if [ "x$target" != "x" ]
		then
			cd $target
		fi
		pwd
	}
fi

# go _u_p to the specified directory OR number of levels if it is a number
# can match directory boundary with /
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
		cd "$(pwd | sed 's!\('$1'[^/]*/\).*$!\1!')"
	fi
	pwd
}

# go to directory from dir _h_istory
# If no argument is given, prints cwd history.
# This first looks for a match at the deepest level in the directory for every
# item in the history, then works its way up the tree.
# It cannot match across directory boundaries
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
	[ "x$target" != "x" ] && cd "$target"
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
	target="$(awk '$1 ~ "'"$1"'"{$1="";print substr($0,2);exit}' $SHELLDIR/dirmarks)"
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

# "/bin/zsh" should be the value of $SHELL if this config is parsed.  This line
# should not be necessary, but it's not a bad idea to have just in case.
export SHELL="/bin/bash"

# This is where custom shell files are stored
SHELLDIR="$HOME/.bash"
mkdir -p $SHELLDIR

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
