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

case "$(hostname)" in
"eddie")
	xinput --set-prop "Elan TrackPoint" "libinput Accel Speed" "-0.6"
	xinput --set-prop "Elan Touchpad" "Device Enabled" "0"
	;;
esac

for user in web games misc fin; do
	xhost +local:$(hostname):${user}
done

# Disable the system beep.
xset s off

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
tail -f /dev/null
