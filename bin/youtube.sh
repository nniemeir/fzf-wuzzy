#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

. "$SCRIPT_DIR/common.sh" || {
    echo "Error: common.sh missing from script directory"
    exit 1
}

depends fzf
depends mpv
depends yt-dlp

while true; do
    printf "Enter a search query: "
    read -r query

    if [ -z "$query" ]; then
        break
    fi

    results=$(yt-dlp --no-warnings "ytsearch10:$query" --print "%(title)s"$'\t'"%(webpage_url)s")
    selection=$(printf "%s" "$results" | awk -F '\t' '{print $1}' | fzf)
    url=$(printf "%s" "$results" | awk -F '\t' -v sel="$selection" '$1 == sel {print $2}')

    if [ -z "$url" ]; then
        echo "Error: No link found for '$selection'"
        exit 1
    fi

    mpv "$url"
done