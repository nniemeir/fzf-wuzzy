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
depends nvim

filename=$(find $DOTFILES_PATH -type f -print | fzf $FZF_DEFAULT_OPTS --prompt="Edit a config file:" | awk '{print $1}')
if [ -n "$filename" ]; then
    nvim "$filename"
fi