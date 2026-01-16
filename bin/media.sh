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

# Construct the menu itself
choice=$(echo -e "Books\nFilms\nGames\nMusic\nTelevision" | fzf $FZF_DEFAULT_OPTS --prompt="Select Category: ")

case "$choice" in 
        "Books")
            $(cd "$(dirname "$0")" && pwd)/books.sh
            ;;
        "Films")
            $(cd "$(dirname "$0")" && pwd)/films.sh
            ;;
        "Games")
            $(cd "$(dirname "$0")" && pwd)/games.sh
            ;;
        "Music")
            $(cd "$(dirname "$0")" && pwd)/music.sh
            ;;
        "Television")
            $(cd "$(dirname "$0")" && pwd)/television.sh
            ;;
esac