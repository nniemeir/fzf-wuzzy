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

depends fzf
depends grim

mkdir -p "$SCREENSHOT_PATH"

file=ps_$(date +"%Y%m%d%H%M%S").png

selection=$(printf "Selected Area\nWhole Screen" | fzf $FZF_DEFAULT_OPTS --prompt="Screenshot > ")

if [ -z "$selection" ]; then
	exit 0
fi

case "$selection" in
	"Selected Area")
		echo "Taking screenshot in 3 seconds..."
		sleep 3
		grim -g "$(slurp)" "$SCREENSHOT_PATH"/"$file"
		;;
	"Whole Screen")
		echo "Taking screenshot in 3 seconds..."
		sleep 3
		grim "$SCREENSHOT_PATH"/"$file"
	;;
esac

if [ -f "$SCREENSHOT_PATH/$file" ]; then
	notify-send "Screenshot Saved" -i "$SCREENSHOT_PATH"/"$file"
fi

if [ ! "$(ls "$SCREENSHOT_PATH")" ]; then
	rm -rf "$SCREENSHOT_PATH"
fi
