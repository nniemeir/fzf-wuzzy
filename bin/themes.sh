#! /bin/sh
# List gathered from Papirus-Folders

source $(cd "$(dirname "$0")" && pwd)/../config/preferences.conf || {
    echo "Error: No configuration file found."
    exit 1
}

source $(cd "$(dirname "$0")" && pwd)/common.sh || {
    echo "Error: common.sh missing from script directory"
    exit 1
}

depends flatpak
depends fzf
depends papirus-folders

accents="adwaita\nblack\nblue\nbluegrey\nbreeze\nbrown\ncarmine\ncyan\ndarkcyan\ndeeporange\ngreen\ngrey\nindigo\nmagenta\nnordic\norange\npalebrown\npaleorange\npink\nred\nteal\nviolet\nwhite\nyaru\nyellow"
theme=$(ls $HOME/.local/share/themes/ | fzf $FZF_DEFAULT_OPTS)

if [ -n "$theme" ]; then
	accent=$(echo -e "$accents" | fzf $FZF_DEFAULT_OPTS)
else
	exit 0
fi

if [ -n "$accent" ]; then
	gsettings set org.gnome.desktop.wm.preferences theme "$theme"
	gsettings set org.gnome.desktop.interface gtk-theme "$theme"
	gsettings set org.gnome.desktop.interface icon-theme "Papirus"
	sudo flatpak override --filesystem=$HOME/.local/share/themes/
	sudo flatpak override --env=GTK_THEME="$theme"
	papirus-folders -t Papirus -C "$accent"
else
	exit 0
fi
