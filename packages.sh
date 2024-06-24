#!/bin/sh

if ! command -v stow >/dev/null 2>&1; then
    echo "Missing \`stow\` executable; make sure to have it installed!" >&2
    exit 1
fi

if [ "$#" -gt 0 ] && [ "$1" != remove ]; then
    echo "Usage: ./packages.sh [remove]" >&2
    echo "  Install or remove all \`stow\` packages in this directory." >&2
    echo "  Run with \`remove\` to uninstall the packages." >&2
    exit 1
fi

for file in *; do
    if [ -d "$file" ]; then
        if [ "$1" != remove ]; then
            stow -v "$file"
        else
            stow -Dv "$file"
        fi
    fi
done
