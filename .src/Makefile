.PHONY: all clean install_debian_dependencies

local: dwm dwmstatus dmenu scron xcape sxiv vim swarp
root: slock disable_at_services
all: local root

jobs := $(shell awk '$$1 == "processor" {x=$$3}END{print x+2}' /proc/cpuinfo)

clean:
	- rm ~/.bin/dwm
	- rm ~/.bin/dwmstatus
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
	- rm ~/.bin/scron
	- rm -r ~/.opt/

install_apt_dependencies:
	sudo apt-get install libgtk2.0-dev libncurses5 libncurses5-dev libpango1.0-dev libx11-dev libxft-dev libxt-dev libxtst-dev ncurses-dev python-dev libimlib2-dev libjbig2dec0-dev libopenjpeg-dev

install_yum_dependencies:
	sudo yum install libX11-devel libXft-devel libXinerama-devel libXtst-devel imlib2-devel libjpeg-turbo-devel jbig2dec-devel openjpeg-devel ncurses-devel libSM-devel libXt-devel

disable_at_services:
	- cd /usr/share/dbus-1/services/ && \
		grep '^Exec=' org.a11y.Bus.service && \
		sed 's/^Exec=/#Exec=/' org.a11y.Bus.service > /tmp/org.a11y.Bus.service-new && \
		sudo mv /tmp/org.a11y.Bus.service-new org.a11y.Bus.service
	- cd /usr/share/dbus-1/services/ && \
		grep '^Exec=' org.a11y.atspi.Registry.service && \
		sed 's/^Exec=/#Exec=/' org.a11y.atspi.Registry.service > /tmp/org.a11y.atspi.Registry.service-new && \
		sudo mv /tmp/org.a11y.atspi.Registry.service-new org.a11y.atspi.Registry.service


dwm: $(HOME)/.bin/dwm
$(HOME)/.bin/dwm: dwm/*.c dwm/*.h
	cd dwm && make clean && make
	mkdir -p ~/.bin/
	- [ -e ~/.bin/dwm ] && mv ~/.bin/dwm /tmp/running-dwm
	cp dwm/dwm ~/.bin/dwm
	- [ -e /tmp/running-dwm ] && rm /tmp/running-dwm

dwmstatus: $(HOME)/.bin/dwmstatus
$(HOME)/.bin/dwmstatus: dwmstatus/*.c
	cd dwmstatus && make clean && make
	mkdir -p ~/.bin/
	- [ -e ~/.bin/dwmstatus ] && mv ~/.bin/dwmstatus /tmp/running-dwmstatus
	cp dwmstatus/dwmstatus ~/.bin/dwmstatus
	- [ -e /tmp/running-dwmstatus ] && rm /tmp/running-dwmstatus

dmenu: $(HOME)/.bin/dmenu
$(HOME)/.bin/dmenu: dmenu/*.c dmenu/*.h
	cd dmenu && make clean && make
	mkdir -p ~/.bin/
	cp dmenu/dmenu ~/.bin/dmenu
	cp dmenu/dmenu_run ~/.bin/dmenu_run
	cp dmenu/stest ~/.bin/stest

scron: $(HOME)/.bin/scron
$(HOME)/.bin/scron: scron/*.c scron/*.h
	cd scron && make clean && make
	mkdir -p ~/.bin/
	cp scron/crond ~/.bin/scron

xcape: $(HOME)/.bin/xcape
$(HOME)/.bin/xcape: xcape/*.c
	- cd xcape && make clean
	- cd xcape && make
	mkdir -p ~/.bin/
	- [ -e ~/.bin/xcape ] && mv ~/.bin/xcape /tmp/running-xcape
	cp xcape/xcape ~/.bin/xcape
	- [ -e /tmp/running-xcape ] && rm /tmp/running-xcape

sxiv: $(HOME)/.bin/sxiv
$(HOME)/.bin/sxiv: sxiv/*.c
	cd sxiv && make clean && make
	mkdir -p ~/.bin/ && cp sxiv/sxiv ~/.bin/sxiv

paraPDF: $(HOME)/.bin/mupdf
$(HOME)/.bin/mupdf:
	cd paraPDF && make build=release CFLAGS='-DJBIG_NO_MEMENTO'
	mkdir -p ~/.bin/ && cp paraPDF/build/release/mupdf ~/.bin/mupdf

vim: $(HOME)/.bin/vim
$(HOME)/.bin/vim:
	cd vim && make distclean
	cd vim && ./configure --prefix=$(HOME)/.opt/vim/ --with-features=huge --with-x --with-python-config-dir=/usr/lib/python2.7/config --enable-pythoninterp=yes --enable-gui=yes --enable-option-checking
	cd vim && make clean && make
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
	cd slock && sed 's,^PREFIX =.*,PREFIX = /opt/slock/,' config.mk > config.mk-new && mv config.mk-new config.mk
	cd slock && make clean && make
	cd slock && echo "need sudo to install slock" && umask 022 && sudo make install
	sudo ln -sf /opt/slock/bin/slock /usr/local/bin/slock
