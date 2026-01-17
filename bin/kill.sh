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

PID=$(ps -u "$USER" -o pid,comm | awk 'NR>1' | fzf $FZF_DEFAULT_OPTS --prompt="Kill Process:" | awk '{print $1}')
if [ -n "$PID" ]; then
    kill -9 "$PID"
fi
