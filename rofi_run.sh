#!/bin/sh

programs=`ls /usr/bin | rofi -dmenu -i -multi-select -p "program"`
for program in $programs; do
    $program &
done
