#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

. "$SCRIPT_DIR/common.sh" || {
    echo "Error: common.sh missing from script directory"
    exit 1
}

depends fzf
depends jq

echo "$(whoami)@$(hostname)"
echo "---------------------"
echo "Date: $(date +"%B %d, %Y - %H:%M %Z")"
echo "OS: $(grep '^PRETTY_NAME=' /etc/os-release \
  | tr -d '\r' \
  | cut -d= -f2- \
  | tr -d '"')"
echo "Kernel: $(uname -sr)"
echo "Uptime: $(uptime -p)"
echo "Current IP: $(hostname -i | awk '{print $2}')"
echo "Packages: $(dnf list --installed | wc -l) (dnf), $(flatpak list | awk 'NR>1 {print $1}' | wc -l) (flatpak)"
echo "WM: $XDG_CURRENT_DESKTOP"
echo "Resolution: $(swaymsg -t get_outputs | jq -r '.[] | .current_mode | "\(.width)x\(.height)"')"
echo "CPU: $(lscpu | grep 'Model name' | sed 's/Model name:\s*//')"
echo "GPU: $(lspci | grep -E 'VGA|3D' | sed 's/.*controller: //')"
echo "Memory: $(free -m | awk '/Mem/ {print $3 " / " $2}') MB"
echo "Theme: $(gsettings get org.gnome.desktop.interface gtk-theme | tr -d "'")"
echo "Icons: $(gsettings get org.gnome.desktop.interface icon-theme | tr -d "'")"
echo "Shell: $SHELL"
echo "Terminal: $TERM"
echo "Active Bluetooth Device: $(bluetoothctl info | grep "Name" | awk -F ': ' '{print $2}')"
