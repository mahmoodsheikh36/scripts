#!/bin/sh

programs=`ls /usr/bin | shuf | rofi -dmenu -i -multi-select -p "program"`
for program in $programs; do
    $program &
    notify-send "launched $program"
done
