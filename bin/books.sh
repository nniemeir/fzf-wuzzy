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
depends zathura

finished=false
while [ "$finished" = "false" ]; do
    selection=$(find "$BOOKS_PATH" -type f \( -name "*.epub" -o -name "*.pdf" \) | sort -u | fzf $FZF_DEFAULT_OPTS)
    if [ -z "$selection" ]; then
        finished=true
    else
        zathura "$BOOKS_PATH/$selection".* 2>/dev/null &
    fi
done