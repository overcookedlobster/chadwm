#!/bin/dash

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
. ~/.config/chadwm/scripts/bar_themes/tundra

cpu() {
  cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

  printf "^c$black^ ^b$green^ CPU"
  printf "^c$white^ ^b$grey^ $cpu_val ^b$black^"
}

pkg_updates() {
  #updates=$({ timeout 20 doas xbps-install -un 2>/dev/null || true; } | wc -l) # void
  updates=$({ timeout 20 checkupdates 2>/dev/null || true; } | wc -l) # arch
  # updates=$({ timeout 20 aptitude search '~U' 2>/dev/null || true; } | wc -l)  # apt (ubuntu, debian etc)

  if [ -z "$updates" ]; then
    printf "  ^c$green^    Fully Updated"
  else
    printf "  ^c$white^    $updates"" updates"
  fi
}

battery() {
  val="$(cat /sys/class/power_supply/BAT0/capacity)"
  printf "^c$black^ ^b$red^ BAT"
  printf "^c$white^ ^b$grey^ $val ^b$black^"

}

nvme_temp() {
  temp=$(cat /tmp/nvme_temp 2>/dev/null || echo "N/A")
  printf "^c$black^ ^b$blue^ NVME"
  printf "^c$white^ ^b$grey^ $temp°C ^b$black^"
}

brightness() {
  printf "^c$red^   "
  printf "^c$red^%.0f\n" $(cat /sys/class/backlight/*/brightness)
}

mem() {
  printf "^c$red^^b$black^  "
  printf "^c$red^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

volume() {
  volume=$(amixer sget Master 2>/dev/null | awk -F'[][]' 'END{ print $2 }' | sed 's/%//g' | tr -d '[:space:]')
  status=$(amixer sget Master 2>/dev/null | awk -F'[][]' 'END{ print $4 }' | tr -d ' ')
  if [ "$status" = "off" ]; then
    printf "^c$black^ ^b$red^ 󰝟"
    printf "^c$white^ ^b$grey^ Muted ^b$black^"
  else
    printf "^c$black^ ^b$blue^ 󰕾"
    printf "^c$white^ ^b$grey^ $volume%% ^b$black^"
  fi
}

wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	up) printf "^c$black^ ^b$blue^ 󰤨 ^d^%s" " ^c$blue^Connected" ;;
	down) printf "^c$black^ ^b$blue^ 󰤭 ^d^%s" " ^c$blue^Disconnected" ;;
	esac
}

clock() {
	printf "^c$black^ ^b$darkblue^ 󱑆 "
	printf "^c$black^^b$blue^ $(date '+%H:%M')  "
}

while true; do

  [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && updates=$(pkg_updates)
  interval=$((interval + 1))

  sleep 1 && xsetroot -name "$(pkg_updates) $(cpu) $(battery) $(nvme_temp) $(volume) $(mem) $(wlan) $(clock)"
done
