#!/bin/sh

if ! command -v nix >/dev/null 2>&1; then
    echo "Missing \`nix\` executable; make sure to have it installed!" >&2
    exit 1
fi

if [ "$#" -gt 0 ] && [ "$1" != remove ]; then
    echo "Usage: ./dependencies.sh [remove]" >&2
    echo "  Install or remove all dependencies for this system." >&2
    echo "  Run with \`remove\` to uninstall the dependencies." >&2
    exit 1
fi

currentSystem="$(nix eval --impure --raw --expr 'builtins.currentSystem')"

if [ "$1" != remove ]; then
    nix profile install --impure ".#packages.${currentSystem}" --priority 6
else
    nix profile remove --impure "${currentSystem}"
fi
