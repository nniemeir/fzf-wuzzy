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

prompt_season() {
	clear
	local show_selection="$1"
	local seasons
	seasons=$(find "$SHOWS_PATH/$show_selection" -mindepth 1 -maxdepth 1 -type d | sort | sed "s|$SHOWS_PATH/$show_selection/||")
	local season_selection
	season_selection=$(echo "$seasons" | fzf $FZF_DEFAULT_OPTS)
	if [ -z "$season_selection" ]; then
		main
	else
		prompt_episode "$show_selection" "$season_selection"
	fi
}

prompt_episode() {
	local show_selection="$1"
	local season_selection="$2"
	local finished="0"
	while [ $finished == "0" ]; do
		clear
		local episode_files
		episode_files=$(find "$SHOWS_PATH/$show_selection/$season_selection" -type f \( -name "*.mkv" -o -name "*.mp4" \) | sort)
		local episode_selection
		episode_selection=$(echo "$episode_files" | fzf $FZF_DEFAULT_OPTS)
		if [ -z "$episode_selection" ]; then
			prompt_season "$show_selection"
		else
			mpv "$episode_selection" --fullscreen >/dev/null 2>&1 &
		fi
	done
}

main() {
    local shows=$(find "$SHOWS_PATH" -mindepth 1 -maxdepth 1 -type d | sort | sed "s|$SHOWS_PATH/||")
    local show_selection=$(echo "$shows" | fzf $FZF_DEFAULT_OPTS)
    if [ -z "$show_selection" ]; then
        exit 0
    else
        prompt_season "$show_selection"
    fi
}

main "$@"
