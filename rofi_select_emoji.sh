#!/bin/sh
# copy an emoji to clipboard using rofi

emoji=`cat ~/workspace/scripts/emoji.txt | rofi -dmenu -p emoji -i -sort | cut -d " " -f1 | tr -d '\n'`
if [ ! -z $emoji ]; then
    echo -n $emoji | xclip -selection copy
    notify-send "copied $emoji to clipboard"
fi
