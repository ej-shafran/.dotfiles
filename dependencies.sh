#!/bin/sh

currentSystem="$(nix eval --impure --raw --expr 'builtins.currentSystem')"

if [ "$1" != remove ]; then
    nix profile install --impure ".#packages.${currentSystem}" --priority 6
else
    nix profile remove --impure "${currentSystem}"
fi
