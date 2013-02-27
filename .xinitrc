# ==============================================================================
# = paradigm's .xinitrc                                                        =
# ==============================================================================

# Use a solid black background.
xsetroot -solid "#000000"

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

if [ "$(uname -n)" = "am" ]
then
	rmmouse&
	xbacklight -set 30%
fi

# If the xcape program is available, use it.
if which xcape >/dev/null
then
	xcape
fi

# Run the window manager and auxiliary programs.
dwmstatus&
dwm&

# Do not close X11 automatically when the window manager closes.
while true; do sleep 1d; done
