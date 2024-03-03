#!/bin/sh

IMG=$(mktemp -u --suffix=.lock.png)
scrot "$IMG"
convert "$IMG" -blur 2x2  -charcoal 1 -colorize 70% "$IMG"
convert "$IMG" -blur 1x1  -implode 1 -colorize 20% "$IMG"
convert "$IMG" -scale 20% -scale 500% "$IMG"
if ! i3lock -i "$IMG"; then
    rm "$IMG"
    return 1
fi
xset dpms force off
rm "$IMG"
