#!/bin/sh

for file in *; do
    if [ -d "$file" ]; then
        stow -v "$@" "$file"
    fi
done
