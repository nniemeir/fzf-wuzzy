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
depends mpv

if [ ! -d "$MUSIC_PATH" ]; then
    echo "Error: Music directory not found: $MUSIC_PATH"
    exit 1
fi

cd "$MUSIC_PATH" || exit 1

while true; do
	music_files=$(find "$MUSIC_PATH" -type f \( -iname "*.mp3" -o -iname "*.flac" -o -iname "*.ogg" \) | sort)
	selection=$(echo "$music_files" | sed "s|$MUSIC_PATH/||" | fzf $FZF_DEFAULT_OPTS --preview="ffprobe -v error -show_entries format_tags=,title,artist,album,genre,date -of default=noprint_wrappers=1 $MUSIC_PATH/{} | awk -F ':' '{print \$2}'" --preview-window=right:70%:wrap --prompt="Select Song: ")	
	if [ -z "$selection" ]; then
		break
	fi
	mpv --msg-level=all=status --no-video "$MUSIC_PATH/$selection"
done