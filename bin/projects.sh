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
depends flatpak

selection=$(ls "$PROJECTS_PATH" | fzf $FZF_DEFAULT_OPTS)	

if [ -z "$selection" ]; then
    exit 0
else
    flatpak run com.visualstudio.code-oss "$PROJECTS_PATH/$selection"
fi
