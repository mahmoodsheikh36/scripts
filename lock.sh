#!/bin/sh

if [ -f /tmp/scrot.png ]; then rm /tmp/scrot.png; fi
scrot /tmp/scrot.png
convert -swirl 360 -blur 0x7 /tmp/scrot.png /tmp/edited_scrot.png
i3lock -i /tmp/edited_scrot.png
