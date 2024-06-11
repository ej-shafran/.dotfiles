#!/bin/sh

for file in *; do
    if [ -d "$file" ]; then
        if [ "$1" != remove ]; then
            stow -v "$file"
        else
            stow -Dv "$file"
        fi
    fi
done
