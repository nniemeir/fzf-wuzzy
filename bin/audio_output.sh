#!/bin/sh
# This is a modified version of Bread On Penguins audioswitch dmenu script adapted to work with fzf 

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
depends jq
depends pactl

sinks_json=$(pactl -f json list sinks)

# Create a list of sinks with pretty names
options=$(printf "%s" "$sinks_json" | jq -r '.[] | .description')

# Let the user select a description
selection=$(printf "%s" "$options" | fzf $FZF_DEFAULT_OPTS --prompt="Output:")

if [ -z "$selection" ]; then
    exit 0
fi

# Extract the corresponding sink name
sink_name=$(printf "%s" "$sinks_json" | jq -r --arg sink_pretty_name "$selection" '.[] | select(.description == $sink_pretty_name) | .name')

# Set the selected sink as default
if [ -n "$sink_name" ]; then
    pactl set-default-sink "$sink_name"
    notify-send "fzf-wuzzy 🐻 — Set Audio Output" "$selection"
fi
