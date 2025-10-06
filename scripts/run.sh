#!/bin/sh

xrdb merge ~/.Xresources
nitrogen --restore &
xset r rate 200 50 &
xinput set-prop 9 "libinput Tapping Enabled" 1 &
xinput set-prop 9 "libinput Tapping Button Mapping Enabled" 0 1 &
sxhkd -c ~/.config/chadwm/sxhkd/sxhkdrc &
picom &

dash ~/.config/chadwm/scripts/bar.sh &
while type chadwm >/dev/null; do chadwm && continue || break; done
