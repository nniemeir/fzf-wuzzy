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

if [ ! -d "$BOOKMARKS_FILE" ]; then
    echo "Error: Bookmarks CSV not found: $BOOKMARKS_FILE"
    exit 1
fi

title=$(awk -F ";" 'NR>1 {print $1}' $BOOKMARKS_FILE | sort -u | fzf $FZF_DEFAULT_OPTS)
if [[ -z "$title" ]]; then exit 0; fi
link=$(awk -F ";" -v t="$title" '$1 = t { print $2 }' $BOOKMARKS_FILE)
xdg-open "$link"
