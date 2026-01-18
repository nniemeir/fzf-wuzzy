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

dir="${dir/#\~/$HOME}"

formats=$(magick identify -list format | awk '$3 ~ /rw/ {print $1}' | tr -d \* | tr 'A-Z' 'a-z')
input=$(printf "%s" "$formats" | fzf --prompt="Select input format: ")

if [ -z "$input" ]; then
    exit 0
fi

output=$(printf "%s" "$formats" | fzf --prompt="Select output format: ")

if [ -z "$output" ]; then
    exit 0
fi

before=$(find "$dir" -maxdepth 1 -type f -iname "*.$input" | wc -l)

find "$dir" -maxdepth 1 -type f -iname "*.$input" -exec mogrify -format "$output" {} \;

before=$(find "$dir" -maxdepth 1 -type f -iname "*.$output" | wc -l)

count=$((after - before))

notify-send "fzf-wuzzy 🐻 — Converted Images" "$count files converted"
