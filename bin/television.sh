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
depends mpv

if [ ! -d "$TELEVISION_PATH" ]; then
    echo "Error: Television directory not found: $TELEVISION_PATH"
    exit 1
fi

prompt_season() {
	clear
	local show_selection="$1"
	local seasons
	seasons=$(find "$TELEVISION_PATH/$show_selection" -mindepth 1 -maxdepth 1 -type d | sort | sed "s|$TELEVISION_PATH/$show_selection/||")
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
	while true; do
		clear
		local episode_files
		episode_files=$(find "$TELEVISION_PATH/$show_selection/$season_selection" -type f \( -name "*.mkv" -o -name "*.mp4" \) | sort)
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
    local television=$(find "$TELEVISION_PATH" -mindepth 1 -maxdepth 1 -type d | sort | sed "s|$TELEVISION_PATH/||")
    local show_selection=$(echo "$television" | fzf $FZF_DEFAULT_OPTS)
    if [ -z "$show_selection" ]; then
        exit 0
    else
        prompt_season "$show_selection"
    fi
}

main "$@"
