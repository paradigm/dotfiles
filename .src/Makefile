.PHONY: all clean install_debian_dependencies

local: dwm dmenu xcape sxiv paraPDF vim swarp
root: slock
all: local root

clean:
	- rm ~/.bin/dwm
	- rm ~/.bin/xcape
	- rm ~/.bin/sxiv
	- rm ~/.bin/mupdf
	- rm ~/.bin/vim
	- rm ~/.bin/vi
	- rm ~/.bin/vimdiff
	- rm ~/.bin/swarp
	- rm ~/.bin/dmenu
	- rm ~/.bin/dmenu_run
	- rm ~/.bin/stest
	- rm -r ~/.opt/

install_debian_dependencies:
	sudo apt-get install libgtk2.0-dev libncurses5 libncurses5-dev libpango1.0-dev libx11-dev libxft-dev libxt-dev libxtst-dev ncurses-dev python-dev

dwm: $(HOME)/.bin/dwm
$(HOME)/.bin/dwm: dwm/*.c dwm/*.h
	cd dwm && git reset --hard
	cd dwm && git clean -f -d
	cd dwm && make
	mkdir -p ~/.bin/
	- [ -e ~/.bin/dwm ] && mv ~/.bin/dwm /tmp/running-dwm
	cp dwm/dwm ~/.bin/dwm
	- [ -e /tmp/running-dwm ] && rm /tmp/running-dwm

dmenu: $(HOME)/.bin/dmenu
$(HOME)/.bin/dmenu: dmenu/*.c dmenu/*.h
	cd dmenu && git reset --hard
	cd dmenu && git clean -f -d
	cd dmenu && make
	mkdir -p ~/.bin/
	cp dmenu/dmenu ~/.bin/dmenu
	cp dmenu/dmenu_run ~/.bin/dmenu_run
	cp dmenu/stest ~/.bin/stest

xcape: $(HOME)/.bin/xcape
$(HOME)/.bin/xcape: xcape/*.c
	cd xcape && git reset --hard
	cd xcape && git clean -f -d
	cd xcape && make
	mkdir -p ~/.bin/ && cp xcape/xcape ~/.bin/xcape

sxiv: $(HOME)/.bin/sxiv
$(HOME)/.bin/sxiv: sxiv/*.c
	cd sxiv && git reset --hard
	cd sxiv && git clean -f -d
	cd sxiv && make
	mkdir -p ~/.bin/ && cp sxiv/sxiv ~/.bin/sxiv

paraPDF: $(HOME)/.bin/mupdf
$(HOME)/.bin/mupdf:
	cd paraPDF && git reset --hard
	cd paraPDF && git clean -f -d
	cd paraPDF && make build=release
	mkdir -p ~/.bin/ && cp paraPDF/build/release/mupdf ~/.bin/mupdf

vim: $(HOME)/.bin/vim
$(HOME)/.bin/vim:
	cd vim && git reset --hard
	cd vim && git clean -f -d
	cd vim && ./configure --prefix=$(HOME)/.opt/vim/ --with-features=huge --with-x --with-python-config-dir=/usr/lib/python2.7/config --enable-pythoninterp=yes --enable-gui=yes --enable-option-checking
	cd vim && make
	cd vim && make install
	ln -sf $(HOME)/.opt/vim/bin/vim ~/.bin/vim
	ln -sf $(HOME)/.opt/vim/bin/vim ~/.bin/vi
	ln -sf $(HOME)/.opt/vim/bin/vim ~/.bin/vimdiff

swarp: $(HOME)/.bin/swarp
$(HOME)/.bin/swarp:
	[ -e swarp-0.1.tar.gz ] || wget "http://dl.suckless.org/tools/swarp-0.1.tar.gz"
	[ -d swarp-0.1 ] || tar xvf swarp-0.1.tar.gz
	cd swarp-0.1 && make
	mkdir -p ~/.bin/ && cp swarp-0.1/swarp ~/.bin/swarp

slock: $(HOME)/.bin/slock
$(HOME)/.bin/slock: slock/*.c
	sudo -l | grep '(ALL) ALL'
	cd slock && git reset --hard
	cd slock && git clean -f -d
	cd slock && sed 's,^PREFIX =.*,PREFIX = /opt/slock/,' config.mk > config.mk-new && mv config.mk-new config.mk
	cd slock && make
	cd slock && echo "need sudo to install slock" && umask 022 && sudo make install
	sudo ln -sf /opt/slock/bin/slock /usr/local/bin/slock
