#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

source $SCRIPT_DIR/common.sh || {
    echo "Error: common.sh missing from script directory"
    exit 1
}

depends fzf
depends mpv
depends yt-dlp

read -p "Enter a search query: " query
results=$(yt-dlp --no-warnings "ytsearch10:$query" --print "%(title)s\t%(webpage_url)s")

selection=$(echo -e "$results" | awk -F '\t' '{print $1}' | fzf)
url=$(echo -e "$results" | awk -F '\t' -v sel="$selection" '$1 = sel {print $2}')

mpv $url
