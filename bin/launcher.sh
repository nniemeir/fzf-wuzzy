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

depends flatpak
depends fzf

# List Flatpak app IDs
list_flatpaks() {
    flatpak list --app --columns=application \
        | awk 'NR>1 {print $1}' \
        | sort -u
}

list_gui_apps() {
    grep -Rl "Type=Application" /usr/share/applications ~/.local/share/applications 2>/dev/null \
        | xargs grep -L "NoDisplay=true" \
        | xargs grep "^Name=" \
        | sed 's/.*Name=//' \
        | sort -u
}

# Construct the menu itself
choice=$(printf "%s\n%s" "$(list_flatpaks)" "$(list_gui_apps)" \
    | fzf $FZF_DEFAULT_OPTS --prompt="Launch: ")

# If selection corresponds to a flatpak ID, run it as such in a subshell
if flatpak info "$choice" >/dev/null 2>&1; then
    (swaymsg exec flatpak run "$choice") &
    exit 0
fi

# Otherwise, find it's desktop file and extract the exec command from it
desktop_file=$(grep -Rl "Name=$choice" /usr/share/applications ~/.local/share/applications 2>/dev/null | head -n 1)
exec_cmd=$(grep "^Exec=" "$desktop_file" | sed 's/Exec=//' | sed 's/%.//g')

# Execute in a subshell
(swaymsg exec "$exec_cmd") &