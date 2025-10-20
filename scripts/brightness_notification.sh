#!/bin/sh

. ~/.config/chadwm/scripts/bar_themes/tundra

backlight_dir="/sys/class/backlight/"
card=$(ls "$backlight_dir" 2>/dev/null | head -n 1)

brightness_file="$backlight_dir$card/brightness"
max_brightness_file="$backlight_dir$card/max_brightness"

update_bar_brightness() {
    if [ -f "$brightness_file" ] && [ -f "$max_brightness_file" ]; then
        brightness=$(cat "$brightness_file" 2>/dev/null)
        max_brightness=$(cat "$max_brightness_file" 2>/dev/null)
        if [ -n "$brightness" ] && [ -n "$max_brightness" ]; then
            brightness_percentage=$((brightness * 100 / max_brightness))
            echo "^c$black^ ^b$yellow^ 󰃠^c$white^ ^b$grey^ $brightness_percentage%% ^b$black^" > /tmp/bar_brightness
        fi
    else
        echo "^c$black^ ^b$yellow^ 󰃠^c$white^ ^b$grey^ N/A ^b$black^" > /tmp/bar_brightness
    fi
}

update_bar_brightness

if [ -n "$card" ] && [ -f "$brightness_file" ]; then
    if command -v inotifywait >/dev/null 2>&1; then
        while true; do
            inotifywait -e modify "$brightness_file" 2>/dev/null
            update_bar_brightness
        done
    else
        while true; do
            sleep 1
            update_bar_brightness
        done
    fi
else
    while true; do
        sleep 1
        echo "^c$black^ ^b$yellow^ 󰃠^c$white^ ^b$grey^ N/A ^b$black^" > /tmp/bar_brightness
    done
fi
