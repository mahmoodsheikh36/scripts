#!/bin/sh

options="2 seconds\n3 seconds\n5 seconds\n10 seconds\n"
time=`echo $options | rofi -dmenu -i -p time`
file_to_save_to=$1

sleep `echo $time | cut -d " " -f1`

if [ ! -z "$file_to_save_to" ]; then
    scrot $file_to_save_to
else
    if [ -d ~/media/scrots ]; then
        file_to_save_to=$(echo ~/media/scrots`date | tr " " "_"`)
        scrot $file_to_save_to
    else
        file_to_save_to=~/screenshot.png
        scrot $file_to_save_to
    fi
fi

echo "$file_to_save_to" | xclip -selection c
notify-send "screenshot taken"
