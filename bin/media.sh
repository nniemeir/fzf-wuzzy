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

selection=$(printf "Books\nFilms\nGames\nMusic\nTelevision" | fzf $FZF_DEFAULT_OPTS --prompt="Select Category: ")

if [ -z "$selection" ]; then
    exit 0
fi

case "$selection" in 
        "Books")
            "$SCRIPT_DIR"/books.sh
            ;;
        "Films")
            "$SCRIPT_DIR"/films.sh
            ;;
        "Games")
            "$SCRIPT_DIR"/games.sh
            ;;
        "Music")
            "$SCRIPT_DIR"/music.sh
            ;;
        "Television")
            "$SCRIPT_DIR"/television.sh
            ;;
esac