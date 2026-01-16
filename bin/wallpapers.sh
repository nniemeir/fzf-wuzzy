#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

source $SCRIPT_DIR/../config/preferences.conf || {
    echo "Error: No configuration file found."
    exit 1
}

source $SCRIPT_DIR/common.sh || {
    echo "Error: common.sh missing from script directory"
    exit 1
}

depends fzf

if [ ! -d "$WALLPAPER_PATH" ]; then
    echo "Error: Wallpapers directory not found: $WALLPAPER_PATH"
    exit 1
fi

if [[ $TERM = *kitty* ]]; then
	fzf_cmd=(fzf $FZF_DEFAULT_OPTS --preview "kitty icat --clear --transfer-mode=stream --stdin=no --place=50x50@30x30 $WALLPAPER_PATH/{}")

else
	fzf_cmd=(fzf $FZF_DEFAULT_OPTS)
fi

selection=$(ls $WALLPAPER_PATH | "${fzf_cmd[@]}")

if [ -n "$selection" ]; then
	swaymsg output "*" bg "$WALLPAPER_PATH/$selection" fill &
	sed -i "s|bg .* fill|bg $WALLPAPER_PATH/$selection fill|" "$SWAY_WALLPAPER_CONF_FILE"
else
	exit 0
fi