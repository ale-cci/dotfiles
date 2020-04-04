#!/usr/bin/env sh
# System Statusbar

SEP=│

function s_battery() {
    echo "Batt: $(cat /sys/class/power_supply/BAT0/capacity)%"
}

function s_volume() {
	sound="$(amixer sget Master | awk 'END{print $NF}')"
	case $sound in
		"[on]")
			echo "Vol: $(amixer sget Master | awk 'END{print $4}' | tr -d '[]' )"
			;;
		"[off]")
			echo "Vol: --%"
			;;
	esac
}

function s_calendar() {
    date "+%a %d %b %R"
}

function s_wifi() {
    name=$(nmcli --fields NAME --mode multiline connection show | head -n 1 | awk '{print $2}')
    percentage=$(grep "^\s*w" /proc/net/wireless | awk '{print int($3 *100/70) "%"}')

    echo "$name ▶ $percentage"
}


# Refresh statusbar every 15s
while true
do
    xsetroot -name " $(s_volume) ${SEP} $(s_wifi) $SEP $(s_calendar) ${SEP} $(s_battery) "
    sleep 15s
done
