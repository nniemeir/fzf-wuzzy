#!/bin/sh

read -p "Enter a search query: " query
results=$(yt-dlp --no-warnings "ytsearch10:$query" --print "%(title)s\t%(webpage_url)s")

selection=$(echo -e "$results" | awk -F '\t' '{print $1}' | fzf)
url=$(echo -e "$results" | awk -F '\t' -v sel="$selection" '$1 == sel {print $2}')

mpv $url
