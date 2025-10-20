#!/bin/sh

. ~/.config/chadwm/scripts/bar_themes/tundra

get_volume() {
    amixer sget Master 2>/dev/null | awk -F'[][]' 'END{ print $2 }' | sed 's/%//g' | tr -d '[:space:]'
}

get_mute_status() {
    amixer sget Master 2>/dev/null | awk -F'[][]' 'END{ print $4 }' | tr -d ' '
}

update_bar_volume() {
    volume=$(get_volume)
    mute_status=$(get_mute_status)

    if [ -z "$volume" ]; then
        volume="0"
    fi

    if [ "$mute_status" = "off" ]; then
        echo "^c$black^ ^b$red^ 󰝟^c$white^ ^b$grey^ Muted ^b$black^" > /tmp/bar_volume
    else
        echo "^c$black^ ^b$blue^ 󰕾^c$white^ ^b$grey^ $volume%% ^b$black^" > /tmp/bar_volume
    fi
}

update_bar_volume

if command -v pactl >/dev/null 2>&1; then
    pactl subscribe 2>/dev/null | while IFS= read -r event; do
        if echo "$event" | grep -q "sink" 2>/dev/null; then
            update_bar_volume
        fi
    done
else
    while true; do
        sleep 1
        update_bar_volume
    done
fi
