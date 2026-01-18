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
depends grim
depends magick
depends pavucontrol

list="Overview
Audio Mixer
Audio Output
Batch Convert
Bluetooth
Bookmarks
Color Picker
Configuration Management
Kill Process
Launch An Application
Lock
LUKS Drive Management
Manual Pages
Media
Merrin System Monitor
Notes
Power Off
Projects
Reboot
Screenshot
Suspend
Themes
Wallpapers
YouTube"

op=$(echo "$list" | fzf $FZF_DEFAULT_OPTS --prompt="Select Option:" --preview "
case {} in 
        'Audio Mixer')
            echo 'Opens pavucontrol for audio mixing'
            ;;
        'Audio Output')
            echo 'Allows the user to select an output device'
            ;;
        'Batch Convert')
            echo 'Convert between image file formats with Magick'
            ;;
        'Bookmarks')
            echo 'Displays a list of bookmarks from \$HOME/.dotfiles/Files/Linux/bookmarks.csv and opens selection in default browser'
            ;;
        'Bluetooth')
            echo 'Opens a selection window with bluetooth adapter options'
            ;;
        'Color Picker')
            echo 'Copies the color at the selected location to the clipboard in hexadecimal format'
            ;;
        'Configuration Management')
            echo 'Opens a selection window with all dotfiles listed, opens selection in neovim'
            ;; 
        'Kill Process')
            echo 'Displays all running processes and attempts to kill the one selected by the user'
            ;;
         'Launch An Application')
            echo 'Opens a selection window of GUI dnf and Flatpak applications'
            ;;
         'Lock')
            echo 'Locks the screen via swaylock'
            ;;
        'LUKS Drive Management')
            echo 'Mount/Unmount LUKS drives'
            ;;
        'Manual Pages')
            echo 'Opens a selection window with all manual pages on the system, opens selection via man command'
            ;;
        'Media')
            echo 'Media library menu'
            ;;
        'Merrin System Monitor')
            echo 'Monitor usage percentage and temperatures of CPU, GPU, and RAM'
            ;;
        'Notes')
            echo 'Displays all CSV, Markdown, and Text files in the users notes directory and its subdirectories, opens selection in Neovim'
            ;;
        'Overview')
            echo 'Displays system information'
            ;;
        'Power Off')
            echo 'Shuts down the system via systemctl'
            ;;
        'Projects')
            echo 'Open a programming project in Visual Studio Code'
            ;;
        'Reboot')
            echo 'Reboots the system via systemctl'
            ;;
         'Screenshot')
            echo 'Allows the user to take a screenshot of a selected part of the screen or the entire screen. Saves result to $HOME/Pictures/Screenshots/'
            ;;
        'Suspend')
            echo 'Suspends system via systemctl'
                ;;
         'Themes')
            echo 'Opens a selection window for GTK and icon themes, selections are applied via gsettings'
            ;;
        'Wallpapers')
            echo 'Opens a selection window for wallpapers, selection is applied in SWAY_WALLPAPER_CONF_FILE'
            ;;
        'YouTube')
            echo 'Search for YouTube videos with yt-dlp and play them with mpv'
            ;;
esac
"
)

case "$op" in 
        "Audio Mixer")
            pavucontrol
            ;;
        "Audio Output")
           "$SCRIPT_DIR"/audio_output.sh
            ;;
        "Batch Convert")
           "$SCRIPT_DIR"/batch_convert.sh
            ;;
        "Bluetooth")
           "$SCRIPT_DIR"/bluetooth.sh
            ;;
        "Bookmarks")
           "$SCRIPT_DIR"/bookmarks.sh
            ;;
        "Color Picker")
            grim -g "$(slurp -p)" -t ppm - | magick - -format '%[pixel:p{0,0}]' txt:- | tail -n 1 | cut -d ' ' -f 4 | wl-copy
            ;;
        "Configuration Management")
           "$SCRIPT_DIR"/config.sh
            ;; 
        "Kill Process")
           "$SCRIPT_DIR"/kill.sh
            ;;
         "Launch An Application")
           "$SCRIPT_DIR"/launcher.sh
            ;;
         "Lock")
	        swaylock 
            ;;
        "LUKS Drive Management")
            "$SCRIPT_DIR"/luks.sh
            ;;
        "Manual Pages")
           "$SCRIPT_DIR"/man.sh
            ;;
        "Media")
           "$SCRIPT_DIR"/media.sh
            ;;
        "Merrin System Monitor")
            "$HOME"/.local/bin/merrin
            ;;
        "Notes")
           "$SCRIPT_DIR"/notes.sh
            ;;
        "Overview")
           "$SCRIPT_DIR"/overview.sh
            ;;
        "Power Off")
            shutdown now
            ;;
        "Projects")
           "$SCRIPT_DIR"/projects.sh
            sleep 1
            ;;
        "Reboot")
            reboot
            ;;
         "Screenshot")
           "$SCRIPT_DIR"/grim.sh
            ;;
        "Suspend")
            systemctl "$op"
            ;;
         "Themes")
           "$SCRIPT_DIR"/themes.sh
            ;;
        "Wallpapers")
           "$SCRIPT_DIR"/wallpapers.sh
            ;;
        "YouTube")
            "$SCRIPT_DIR"/youtube.sh
            ;;
esac