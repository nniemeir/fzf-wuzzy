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

choice=$(printf "Connect\nDisconnect\nPower On\nPower Off" | fzf $FZF_DEFAULT_OPTS --prompt="Bluetooth: " | cut -d. -f1)

devices=$(bluetoothctl devices Paired | awk '{print $2, $3}')

if [ "$choice" = "Connect" ]; then
	name=$(echo "$devices" | awk '{print $2}' | fzf $FZF_DEFAULT_OPTS --prompt="Connect: ")
	mac=$(echo "$devices" | grep "$name" | awk '{print $1}')
	if [ -n "$mac" ]; then
	   bluetoothctl connect "$mac"
	fi
elif [ "$choice" = "Disconnect" ]; then
	bluetoothctl disconnect

elif [ "$choice" = "Power On" ]; then
	bluetoothctl power on

elif [ "$choice" = "Power Off" ]; then
	bluetoothctl power off
fi

