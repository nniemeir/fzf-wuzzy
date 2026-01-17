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
depends nvim

if [ ! -d "$NOTE_PATH" ]; then
    echo "Error: Notes directory not found: $NOTE_PATH"
    exit 1
fi

cd "$NOTE_PATH" || exit 1
finished=false
while [ "$finished" = "false" ]; do
	note_files=$(find "$NOTE_PATH" -type f \( -iname "*.csv" -o -iname "*.md" -o -iname "*.tex" -o -iname "*.txt" \))
    	selection=$(echo "$note_files" | sed "s|$NOTE_PATH/||" | fzf $FZF_DEFAULT_OPTS --preview="cat -n {}" --preview-window=right:70%:wrap)	
	if [ -z "$selection" ]; then
		finished=true
	else
		nvim "$NOTE_PATH/$selection"
	fi
done
