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

# Change directory then immediately clear the screen and run `ls`.
cds() {
	cd $1 && clear && ls
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
# - general_(evironmental_variables)                                           -
# ------------------------------------------------------------------------------

# "/bin/zsh" should be the value of $SHELL if this config is parsed.  This line
# should not be necessary, but it's not a bad idea to have just in case.
export SHELL="/bin/bash"

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

# Set the default PDF reader.
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
# - prompt_(evironmental_variables)                                            -
# ------------------------------------------------------------------------------
#
# If root, the prompt should be a red pound sign.
# Otherwise, it should be a blue dollar sign.

if [ "$(id -u)" -eq "0" ]; then
	export PS1=$'\e[0;30m\e[41m#\e[m '
else
	export PS1=$'\e[0;30m\e[47m$\e[m '
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
