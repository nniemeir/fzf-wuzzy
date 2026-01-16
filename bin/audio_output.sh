#!/bin/sh
# This is a modified version of Bread On Penguins audioswitch dmenu script adapted to work with fzf 

source $SCRIPT_DIR/../config/preferences.conf || {
    echo "Error: No configuration file found."
    exit 1
}

source $SCRIPT_DIR/common.sh || {
    echo "Error: common.sh missing from script directory"
    exit 1
}

depends fzf
depends jq
depends pactl

# Create a list of sinks with pretty names
options=$(pactl -f json list sinks | jq -r '.[] | .description')

# Let the user select a description
selection=$(echo "$options" | fzf $FZF_DEFAULT_OPTS --prompt="Output:")

# Extract the corresponding sink name
sink_name=$(pactl -f json list sinks | jq -r --arg sink_pretty_name "$selection" '.[] | select(.description = $sink_pretty_name) | .name')

# Set the selected sink as default
if [ -n "$sink_name" ]; then
    pactl set-default-sink "$sink_name" 
fi
