#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

. "$SCRIPT_DIR/../config/preferences.conf"|| {
    echo "Error: No configuration file found."
    exit 1
}

. "$SCRIPT_DIR/common.sh" || {
    echo "Error: common.sh missing from script directory"
    exit 1
}

depends bluetoothctl
depends fzf

selection=$(printf "Connect\nDisconnect\nPower On\nPower Off" | fzf $FZF_DEFAULT_OPTS --prompt="Bluetooth: ")

if [ -z "$selection" ]; then
	exit 0
fi

#TODO: This doesn't handle multi-word device names properly
devices=$(bluetoothctl devices Paired | awk '{print $2, $3}')

case "$selection" in 
	"Connect")
		name=$(printf "%s" "$devices" | awk '{print $2}' | fzf $FZF_DEFAULT_OPTS --prompt="Connect: ")
		
		if [ -z "$name" ]; then
			exit 0
		fi

		mac=$(printf "%s" "$devices" | grep "$name" | awk '{print $1}')
		
		if [ -n "$mac" ]; then
			bluetoothctl connect "$mac"
		fi
		;;
	"Disconnect")
		bluetoothctl disconnect
		;;
	"Power On")
		bluetoothctl power on
		;;
	"Power Off")
		bluetoothctl power off
		;;
esac