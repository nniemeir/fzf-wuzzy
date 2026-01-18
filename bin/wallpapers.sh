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
depends swaymsg

if [ ! -d "$WALLPAPER_PATH" ]; then
    echo "Error: Wallpapers directory not found: $WALLPAPER_PATH"
    exit 1
fi

case "$TERM" in 
    *kitty*)
        fzf_cmd="fzf $FZF_DEFAULT_OPTS --preview 'kitty icat --clear --transfer-mode=stream --stdin=no --place=50x50@30x30 $WALLPAPER_PATH/{}'"
        ;;
    *)
        fzf_cmd="fzf $FZF_DEFAULT_OPTS"
        ;;
esac

selection=$(find "$WALLPAPER_PATH" -maxdepth 1 -type f -printf "%f\n" | sort | eval "$fzf_cmd")

if [ -z "$selection" ]; then
    exit 0
fi

swaymsg output "*" bg "$WALLPAPER_PATH"/"$selection" fill &

sed -i "s|bg .* fill|bg $WALLPAPER_PATH/$selection fill|" "$SWAY_WALLPAPER_CONF_FILE"
