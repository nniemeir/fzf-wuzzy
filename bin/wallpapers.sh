#!/bin/sh

source $(cd "$(dirname "$0")" && pwd)/../config/preferences.conf || {
    echo "Error: No configuration file found."
    exit 1
}

source $(cd "$(dirname "$0")" && pwd)/common.sh || {
    echo "Error: common.sh missing from script directory"
    exit 1
}

depends fzf

if [[ $TERM == *kitty* ]]; then
	fzf_cmd=(fzf $FZF_DEFAULT_OPTS --preview "kitty icat --clear --transfer-mode=stream --stdin=no --place=50x50@30x30 $WALLPAPER_PATH/{}")

else
	fzf_cmd=(fzf $FZF_DEFAULT_OPTS)
fi

selection=$(ls $WALLPAPER_PATH | "${fzf_cmd[@]}")

if [ -n "$selection" ]; then
	swaymsg output "*" bg "$WALLPAPER_PATH/$selection" fill &
	sed -i "s|bg .* fill|bg $WALLPAPER_PATH/$selection fill|" "$HOME/.dotfiles/Files/Linux/sway/styling.conf"
else
	exit 0
fi
