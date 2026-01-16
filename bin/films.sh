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
depends mpv

finished=false
while [ "$finished" == "false" ]; do
    film_files=$(find "$MOVIES_PATH" -type f \( -name "*.mkv" -o -name "*.mp4" \) | sort)
    selection=$(echo "$film_files" | fzf $FZF_DEFAULT_OPTS)
    if [ -z "$selection" ]; then
        finished=true
    else
        mpv "$selection" --fullscreen >/dev/null 2>&1 &
    fi
done