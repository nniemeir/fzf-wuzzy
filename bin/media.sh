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
            ~/.dotfiles/Files/Linux/fzf/books.sh
            ;;
        "Films")
            ~/.dotfiles/Files/Linux/fzf/films.sh
            ;;
        "Games")
            ~/.dotfiles/Files/Linux/fzf/games.sh
            ;;
        "Music")
            ~/.dotfiles/Files/Linux/fzf/music.sh
            ;;
        "Television")
            ~/.dotfiles/Files/Linux/fzf/television.sh
            ;;
esac