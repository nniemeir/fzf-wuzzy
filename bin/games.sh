#!/bin/sh

SUPPORTED_RUNNERS="BlastEm\nbsnes\nDeSmuME\nDolphin\nFlycast\nHeroic\nLutris\nmGBA\nNestopia\nNone\nPCSX2\nPPSSPP\nRPCS3\nSteam"

main() {
	command -v fzf >/dev/null 2>&1 || {
		echo >&2 "Error: fzf not found"
		exit 1
	}

    source $(cd "$(dirname "$0")" && pwd)/../config/preferences.conf || {
    	echo "Error: No configuration file found."
    	exit 1
	}

	if ! [ -f "$GAMES_FILE" ]; then
		echo "games.csv not found."
		exit 1
	fi

    prompt_runner

	exit 0
}

prompt_runner() {
	local finished="0"
	while [ $finished == "0" ]; do
		local available_runners
		available_runners=$(get_available_runners)

		local available_runners_list
		available_runners_list="All\n$available_runners"

		local runner_selection
		runner_selection=$(echo -e "$available_runners_list" | fzf $FZF_DEFAULT_OPTS)
		if [ -z "$runner_selection" ]; then
			exit 0
		fi

		if [ "$runner_selection" == "All" ]; then
			runner_selection=""
		fi

		runner_games=$(get_matching_games)
		prompt_game "$runner_games"
		clear
		break
	done
}

prompt_game() {
	local runner_games="$1"
	local finished="0"
	while [ $finished == "0" ]; do
		local game_selection
		game_selection=$(echo -e "$runner_games" | fzf $FZF_DEFAULT_OPTS)
		if [ -z "$game_selection" ]; then
			prompt_runner
		else
			local runner
			runner=$(awk 'BEGIN { FS = ";" } /'"$game_selection"'/ { print $2 }' "$GAMES_FILE")
			local game_id
			game_id=$(awk 'BEGIN { FS = ";" } /'"$game_selection"'/ { print $3 }' "$GAMES_FILE")
			launch_game "$runner" "$game_id"
		fi
	done
}


enumerate_runners() {
	case $runner in
	BlastEm) [ -d "$MD_ROMS" ] && flatpak list | grep "com.retrodev.blastem" ;;
	bsnes) [ -d "$SNES_ROMS" ] && flatpak list | grep "dev.bsnes.bsnes" ;;
	DeSmuME) [ -d "$DS_ROMS" ] && flatpak list | grep "org.desmume.DeSmuME" ;;
	Dolphin) [ -d "$GAMECUBE_WII_ROMS" ] && flatpak list | grep "org.DolphinEmu.dolphin-emu" ;;
	Flycast) [ -d "$DREAMCAST_ROMS" ] && flatpak list | grep "org.flycast.Flycast" ;;
	Heroic) command -v heroic ;;
	Lutris) command -v lutris ;;
	mGBA) [ -d "$GBA_ROMS" ] && flatpak list | grep "io.mgba.mGBA" ;;
	Nestopia) [ -d "$NES_ROMS" ] && flatpak list | grep "ca._0ldsk00l.Nestopia" ;;
	PCSX2) [ -d "$PS2_ROMS" ] && flatpak list | grep "net.pcsx2.PCSX2" ;;
	PPSSPP) [ -d "$PSP_ROMS" ] && flatpak list | grep "org.ppsspp.PPSSPP" ;;
	RPCS3) [ -d "$PS3_ROMS" ] && flatpak list | grep "net.rpcs3.RPCS3" ;;
	Steam) command -v steam ;;
	*)
		echo "Error: Invalid Runner"
		exit 1
		;;
	esac
}

get_available_runners() {
	local unavailable_runners=""
	for runner in $(echo -e "$SUPPORTED_RUNNERS"); do
		if [[ ! $(enumerate_runners "$runner") ]]; then
			local unavailable_runners="$unavailable_runners$runner"
		fi
	done

	local available_runners=""
	for runner in $(echo -e "$SUPPORTED_RUNNERS"); do
		if [[ ! "$unavailable_runners" =~ "$runner" ]]; then
			local available_runners
			available_runners="$available_runners$runner\n"
		fi
	done

	available_runners=$(echo -e "$available_runners" | sed -e '$!b' -e '/^\n*$/d')

	echo "$available_runners"
}

get_matching_games() {
	local runner_games
	runner_games=$(awk -v filter="$runner_selection" -v available_runners="$available_runners" 'BEGIN { FS = ";" } {
		if (NR == 1) { next }
		if (filter == "") {
			if (index(available_runners, $2) > 0) {
				print $1;
			}
		}
		else {
			split(filter, runners, /\n/);
			for (i in runners) {
				if ($2 == runners[i]) {
				print $1;
				}
			}
		}
	}' "$GAMES_FILE")

	echo "$runner_games"
}

launch_game() {
	local runner="$1"
	local game_id="$2"
	case $runner in
	BlastEm)
		flatpak run com.retrodev.blastem "$MD_ROMS/$game_id" >/dev/null 2>&1 &
		;;
	bsnes)
		flatpak run dev.bsnes.bsnes "$SNES_ROMS/$game_id" >/dev/null 2>&1 &
		;;
	DeSmuME)
		flatpak run org.desmume.DeSmuME "$DS_ROMS/$game_id" >/dev/null 2>&1 &
		;;
	Dolphin)
		flatpak run org.DolphinEmu.dolphin-emu "$GAMECUBE_WII_ROMS/$game_id" >/dev/null 2>&1 &
		;;
	Flycast)
		flatpak run org.flycast.Flycast "$DREAMCAST_ROMS/$game_id" >/dev/null 2>&1 &
		;;
	Heroic)
		xdg-open heroic://launch/legendary/"$game_id" >/dev/null 2>&1 &
		;;
	Lutris)
		env LUTRIS_SKIP_INIT=1 lutris "lutris:rungame_id/$game_id" >/dev/null 2>&1 &
		;;
	mGBA)
		flatpak run io.mgba.mGBA "$GBA_ROMS/$game_id" >/dev/null 2>&1 &
		;;
	Nestopia)
		flatpak run ca._0ldsk00l.Nestopia "$NES_ROMS/$game_id" >/dev/null 2>&1 &
		;;
	None)
		eval "$game_id >/dev/null 2>&1 &"
		;;
	PCSX2)
		flatpak run net.pcsx2.PCSX2 "$PS2_ROMS/$game_id" >/dev/null 2>&1 &
		;;
	PPSSPP)
		flatpak run org.ppsspp.PPSSPP "$PSP_ROMS/$game_id" >/dev/null 2>&1 &
		;;
	RPCS3)
		flatpak run net.rpcs3.RPCS3 "$PS3_ROMS/$game_id" >/dev/null 2>&1 &
		;;
	Steam)
		steam -applaunch "$game_id" >/dev/null 2>&1 &
		;;
	*)
		echo "The runner $runner is not currently supported"
		;;
	esac
}

main "$@"
