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
depends zathura

if [ ! -d "$BOOKS_PATH" ]; then
    echo "Error: Books directory not found: $BOOKS_PATH"
    exit 1
fi

while true; do
    selection=$(find "$BOOKS_PATH" -type f \( -name "*.epub" -o -name "*.pdf" \) | sort | fzf $FZF_DEFAULT_OPTS)
    
    if [ -z "$selection" ]; then
        break
    fi
    
    zathura "$BOOKS_PATH/$selection".* 2>/dev/null &
done