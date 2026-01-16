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
depends man

manual=$(man -k . | sort -u | awk '{print $1, $2}' | fzf $FZF_DEFAULT_OPTS --prompt="Manuals: " | awk '{print $1}')

if [[ -n "$manual" ]]; then
    man $manual
fi

exit 0
