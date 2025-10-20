#!/usr/bin/env sh

# Set up your monitors here before dwm starts.
# Run `xrandr` in your terminal to see available outputs and modes.
# Example for two monitors:
# xrandr --output eDP-1 --primary --mode 1920x1080 --output HDMI-1 --mode 1920x1080 --right-of eDP-1
# Add your xrandr command here:

xrandr --output HDMI-1 --mode 1920x1080 --pos 0x0 --rotate normal --output eDP-1 --primary --mode 1920x1080 --pos 0x1080 --rotate normal
xrdb merge ~/.Xresources
nitrogen --restore &
xset r rate 200 50 &
xinput set-prop 9 "libinput Tapping Enabled" 1 &
xinput set-prop 9 "libinput Tapping Button Mapping Enabled" 0 1 &
sxhkd -c ~/.config/chadwm/sxhkd/sxhkdrc &
export QT_QPA_PLATFORM=xcb
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_QPA_PLATFORM=xcb
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export _JAVA_AWT_WM_NONREPARENTING=1
picom &

~/.config/chadwm/scripts/bar.sh &
while type chadwm >/dev/null; do chadwm && continue || break; done
