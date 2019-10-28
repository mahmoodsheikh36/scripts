#!/bin/sh

program_to_run=`ls /usr/bin | rofi -dmenu -p "bin to exec" -sort`
if [ ! -z "$program_to_run" ]; then
    $program_to_run & disown
    notify-send "System" "launched $program_to_run"
fi
exit 0
