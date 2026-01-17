#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

. "$SCRIPT_DIR/common.sh" || {
    echo "Error: common.sh missing from script directory"
    exit 1
}

depends fzf
depends magick

printf "Specify a Directory: "
read -r dir

if [ -z "$dir" ]; then 
	dir="./"
fi

formats=$(magick identify -list format | awk '$3 ~ /rw/ {print $1}' | tr -d \*)
input=$(printf "%s" "$formats" | fzf --prompt="Select input format: ")
output=$(printf "%s" "$formats" | fzf --prompt="Select output format: ")

find . -maxdepth 1 -wholename "$dir*.$input" -exec mogrify -format "$dir.$output" {} \;
