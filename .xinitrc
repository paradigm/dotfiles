# ==============================================================================
# = paradigm's .xinitrc                                                        =
# ==============================================================================

# Use a solid black background.
xsetroot -solid "#000000"

# set dpi
xrandr --dpi 96

## This fixes a font issue on Arch Linux.
#xset +fp /usr/share/fonts/local
#xset fp rehash

# Disable certain keys to force the usage of others.
## Unmap backspace (Learn to use ctrl-h).
#xmodmap -e "keycode 22 = "
## Unmap control_l (Learn to use caps_lock).
#xmodmap -e "keycode 37 = "

# Remap caps_lock act like ctrl.
xmodmap -e "clear Lock"
xmodmap -e "keycode 0x42 = Control_L"
xmodmap -e "add Control = Control_L"

# Disable the system beep.
xset s off

# This is required for qgtkstyle.
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# Allow root to run applications
xhost +local:root

# add 100dpi fonts to PATH, fixes steam
xset +fp /usr/share/fonts/X11/100dpi
# adds arch's terminus font to font sources irrelevant of who provides Xorg
if [ -e /bedrock/clients/arch/usr/share/fonts/local/fonts.dir ]
then
	xset +fp /bedrock/clients/arch/usr/share/fonts/local
fi

if [ "$(uname -n)" = "am" ]
then
	rmmouse&
	xbacklight -set 30%
fi

# start xorg user session items
if type sv >/dev/null 2>&1
then
	for service in $(ls $SVDIR/*/start-xorg | awk -F/ '{print $(NF-1)}')
	do
		if type $service >/dev/null 2>&1 && [ -d $SVDIR/$service ]
		then
			sv u $SVDIR/$service
		fi
	done
fi

# Run the window manager
dwm&

# Do not close X11 automatically when the window manager closes.
while true; do sleep 1d; done
