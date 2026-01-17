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

mode=$(printf "Mount\nUnmount" | fzf $FZF_DEFAULT_OPTS)

name=$(awk -F ";" 'NR>1 {print $1}' "$DRIVES_PATH" | sort -u | fzf $FZF_DEFAULT_OPTS)

if [ -z "$name" ]; then
    exit 0
fi

mountpoint=$(awk -F ";" -v t="$name" '$1 == t { print $3 }' "$DRIVES_PATH")

case "$mode" in 
    "Mount")
        dev_entry=$(awk -F ";" -v t="$name" '$1 == t { print $2 }' "$DRIVES_PATH")
        sudo cryptsetup open "/dev/$dev_entry" "$name" 
        sudo mount "/dev/mapper/$name" "$mountpoint"
        ;;
    "Unmount")
        sudo umount "$mountpoint"
        sudo cryptsetup luksClose "$name"
        ;;
esac