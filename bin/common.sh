#!/bin/sh

depends() {
    command -v "$1" >/dev/null 2>&1 || {
        printf "Error: '%s' not found.\n" "$1" >&2
        exit 1
    }
}