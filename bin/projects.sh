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
depends flatpak

if [ ! -d "$PROJECTS_PATH" ]; then
    echo "Error: Projects directory not found: $PROJECTS_PATH"
    exit 1
fi

selection=$(find "$PROJECTS_PATH" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | fzf $FZF_DEFAULT_OPTS)	

if [ -z "$selection" ]; then
    exit 0
fi

flatpak run com.visualstudio.code-oss "$PROJECTS_PATH/$selection" &

