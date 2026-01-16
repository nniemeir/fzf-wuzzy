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
depends grim
depends magick
depends pavucontrol

list="Overview
Audio Mixer
Audio Output
Bluetooth
Bookmarks
Color Picker
Configuration Management
Kill Process
Launch An Application
Lock
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
Wallpapers"

op=$(echo "$list" | fzf $FZF_DEFAULT_OPTS --prompt="Select Option:" --preview '
case {} in 
        "Audio Mixer")
            echo "Opens pavucontrol for audio mixing"
            ;;
        "Audio Output")
            echo "Allows the user to select an output device"
            ;;
        "Bookmarks")
            echo "Displays a list of bookmarks from ~/.dotfiles/Files/Linux/bookmarks.csv and opens selection in default browser"
            ;;
        "Bluetooth")
            echo "Opens a selection window with bluetooth adapter options"
            ;;
        "Color Picker")
            echo "Copies the color at the selected location to the clipboard in hexadecimal format"
            ;;
        "Configuration Management")
            echo "Opens a selection window with all dotfiles listed, opens selection in neovim"
            ;; 
        "Kill Process")
            echo "Displays all running processes and attempts to kill the one selected by the user"
            ;;
         "Launch An Application")
            echo "Opens a selection window of GUI dnf and Flatpak applications"
            ;;
         "Lock")
            echo "Locks the screen via swaylock"
            ;;
        "Manual Pages")
            echo "Opens a selection window with all manual pages on the system, opens selection via man command"
            ;;
        "Media")
            echo "Media library menu"
            ;;
        "Merrin System Monitor")
            echo "Monitor usage percentage and temperatures of CPU, GPU, and RAM"
            ;;
        "Notes")
            echo "Displays all CSV, Markdown, and Text files in the users notes directory and its subdirectories, opens selection in Neovim"
            ;;
        "Overview")
            $(cd "$(dirname "$0")" && pwd)/overview.sh
            ;;
        "Power Off")
            echo "Shuts down the system via systemctl"
            ;;
        "Projects")
            echo "Open a programming project in Visual Studio Code"
            ;;
        "Reboot")
            echo "Reboots the system via systemctl"
            ;;
         "Screenshot")
            echo "Allows the user to take a screenshot of a selected part of the screen or the entire screen. Saves result to ~/Pictures/Screenshots/"
            ;;
        "Suspend")
            echo "Suspends system via systemctl"
                ;;
         "Themes")
            echo "Opens a selection window for GTK and icon themes, selections are applied via gsettings"
            ;;
        "Wallpapers")
            echo "Opens a selection window for wallpapers, selection is applied in ~/.dotfiles/Files/Linux/sway/styling.conf"
            ;;
esac
'
)

case "$op" in 
        "Audio Mixer")
            pavucontrol
            ;;
        "Audio Output")
            $(cd "$(dirname "$0")" && pwd)/audio_output.sh
            ;;
        "Bluetooth")
            $(cd "$(dirname "$0")" && pwd)/bluetooth.sh
            ;;
        "Bookmarks")
            $(cd "$(dirname "$0")" && pwd)/bookmarks.sh
            ;;
        "Color Picker")
            grim -g "$(slurp -p)" -t ppm - | magick - -format '%[pixel:p{0,0}]' txt:- | tail -n 1 | cut -d ' ' -f 4 | wl-copy 
            ;;
        "Configuration Management")
            $(cd "$(dirname "$0")" && pwd)/config.sh
            ;; 
        "Kill Process")
            $(cd "$(dirname "$0")" && pwd)/kill.sh
            ;;
         "Launch An Application")
            $(cd "$(dirname "$0")" && pwd)/launcher.sh
            ;;
         "Lock")
	        swaylock -i ~/Pictures/Wallpapers/dark_morning.jpg --color=282a36  --indicator-radius=100 --indicator-thickness=10 --inside-color=282a36 --inside-clear-color=282a36 --inside-ver-color=282a36 --inside-wrong-color=282a36 --key-hl-color=bd93f9aa --bs-hl-color=ff5555aa --ring-color=44475a90 --ring-ver-color=bd93f9 --ring-clear-color=ff79c611 --line-color=282a36 --line-uses-ring --ring-wrong-color=ff5555 	
            ;;
        "Manual Pages")
            $(cd "$(dirname "$0")" && pwd)/man.sh
            ;;
        "Media")
            $(cd "$(dirname "$0")" && pwd)/media.sh
            ;;
        "Merrin System Monitor")
            ~/.local/bin/merrin
            ;;
        "Notes")
            $(cd "$(dirname "$0")" && pwd)/notes.sh
            ;;
        "Power Off")
            shutdown now
            ;;
        "Projects")
            $(cd "$(dirname "$0")" && pwd)/projects.sh
            sleep 1
            ;;
        "Reboot")
            reboot
            ;;
         "Screenshot")
            $(cd "$(dirname "$0")" && pwd)/grim.sh
            ;;
        "Suspend")
            systemctl $op
            ;;
         "Themes")
            $(cd "$(dirname "$0")" && pwd)/themes.sh
            ;;
        "Wallpapers")
            $(cd "$(dirname "$0")" && pwd)/wallpapers.sh
            ;;
esac

exit 0