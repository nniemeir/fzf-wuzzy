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
depends nvim

while true; do
    filename=$(find "$DOTFILES_PATH" -mindepth 1 -type f -print |  sed "s|$DOTFILES_PATH/||" | sort | fzf $FZF_DEFAULT_OPTS --prompt="Edit a config file:" | awk '{print $1}')

    if [ -n "$filename" ]; then
        nvim "$DOTFILES_PATH/$filename"
    fi
done