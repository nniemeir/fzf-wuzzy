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

depends fzf
depends mpv

if [ ! -d "$FILMS_PATH" ]; then
    echo "Error: Films directory not found: $FILMS_PATH"
    exit 1
fi

finished=false
while [ "$finished" = "false" ]; do
    film_files=$(find "$FILMS_PATH" -type f \( -name "*.mkv" -o -name "*.mp4" \) | sort)
    selection=$(echo "$film_files" | fzf $FZF_DEFAULT_OPTS)
    if [ -z "$selection" ]; then
        finished=true
    else
        mpv "$selection" --fullscreen >/dev/null 2>&1 &
    fi
done