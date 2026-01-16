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

cd "$NOTE_PATH" || exit 1
finished="0"
while [ $finished == "0" ]; do
	note_files=$(find "$NOTE_PATH" -type f \( -iname "*.csv" -o -iname "*.md" -o -iname "*.tex" -o -iname "*.txt" \))
    	selection=$(echo "$note_files" | sed "s|$NOTE_PATH||" | fzf $FZF_DEFAULT_OPTS --preview="cat -n {}" --preview-window=right:70%:wrap)	
	if [ -z "$selection" ]; then
		finished="1"
	else
		nvim "$NOTE_PATH/$selection"
	fi
done
