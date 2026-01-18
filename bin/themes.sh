#! /bin/sh
# List gathered from Papirus-Folders

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

. "$SCRIPT_DIR/../config/preferences.conf"|| {
    echo "Error: No configuration file found."
    exit 1
}

. "$SCRIPT_DIR/common.sh" || {
    echo "Error: common.sh missing from script directory"
    exit 1
}

depends flatpak
depends fzf
depends gsettings
depends papirus-folders

accents="adwaita
black
blue
bluegrey
breeze
brown
carmine
cyan
darkcyan
deeporange
green
grey
indigo
magenta
nordic
orange
palebrown
paleorange
pink
red
teal
violet
white
yaru
yellow"

theme=$(find "$HOME"/.local/share/themes/ -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | sort | fzf $FZF_DEFAULT_OPTS)

if [ -z "$theme" ]; then
	exit 0
fi

accent=$(printf "%s" "$accents" | fzf $FZF_DEFAULT_OPTS)

if [ -z "$accent" ]; then
	exit 0
fi

gsettings set org.gnome.desktop.wm.preferences theme "$theme"
gsettings set org.gnome.desktop.interface gtk-theme "$theme"
gsettings set org.gnome.desktop.interface icon-theme "Papirus"

sudo flatpak override --filesystem="$HOME"/.local/share/themes/
sudo flatpak override --env=GTK_THEME="$theme"

papirus-folders -t Papirus -C "$accent"

notify-send "fzf-wuzzy 🐻 — Set Theme" "$theme"
