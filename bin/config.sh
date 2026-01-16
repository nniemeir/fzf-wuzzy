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
depends nvim

filename=$(find ~/.dotfiles/Files/Linux/ -type f -print | fzf $FZF_DEFAULT_OPTS --prompt="Edit a config file:" | awk '{print $1}')
if [ -n "$filename" ]; then
    nvim "$filename"
fi
