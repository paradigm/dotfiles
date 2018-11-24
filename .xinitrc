#!/bin/sh
# ==============================================================================
# = paradigm's .xinitrc                                                        =
# ==============================================================================

# Use a solid black background.
xsetroot -solid "#000000"

# set dpi
xrandr --dpi 96

# Remap caps_lock act like ctrl.
xmodmap -e "clear Lock"
xmodmap -e "keycode 0x42 = Control_L"
xmodmap -e "add Control = Control_L"

# Disable the system beep.
xset s off

if [ -d /sys/class/power_supply/BAT0/ ]; then
	rmmouse&
	xbacklight -set 30%
fi

if type conctl >/dev/null 2>&1; then
	[ "$(conctl --state xorg)" = "starting" ] && conctl k SIGUSR1 xorg
else
	if type dwm >/dev/null 2>&1; then
		dwm &
		dwmstatus &
	elif type openbox >/dev/null 2>&1; then
		openbox &
	else
		xterm &
	fi

	get-pid dbus-daemon || (dbus-daemon --session --nofork --address "unix:path=/dev/shm/.$(whoami)/S.dbus" &)
	get-pid dunst || (dunst &)
	get-pid xcape || (xcape &)
	get-pid pulseaudio || (pulseaudio &)
	get-pid crond || (crond &)
fi
xterm &

# Do not close X11 automatically when the window manager closes.
while true; do
	sleep infinity
done
