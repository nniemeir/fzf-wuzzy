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
depends mpv

cd "$MUSIC_PATH" || exit 1
finished="0"
while [ $finished == "0" ]; do
	music_files=$(find "$MUSIC_PATH" -type f \( -iname "*.mp3" -o -iname "*.flac" -o -iname "*.ogg" \) | sort -u)
    	selection=$(echo "$music_files" | sed "s|$MUSIC_PATH||" | fzf $FZF_DEFAULT_OPTS --preview="ffprobe -v error -show_entries format_tags=,title,artist,album,genre,date -of default=noprint_wrappers=1 $MUSIC_PATH{} | awk -F ':' '{print \$2}'" --preview-window=right:70%:wrap --prompt="Select Song: ")	
	if [ -z "$selection" ]; then
		finished="1"
	else
		mpv --msg-level=all=status --no-video "$MUSIC_PATH/$selection"
	fi
done