#!/bin/sh
# kill a running process using rofi

process_name=`ps -e | awk '{ print $4 }' | sort -u | rofi -dmenu -i -p "process"`
if [ ! -z $process_name ]; then
    for process in $(pgrep "$process_name");
    do
        if [ ! -z $process ]; then
            kill $process
            if [ ! -z `pgrep $process` ]; then
                kill -9 $process
            fi
        fi
    done
    if [ -z `pgrep $process` ]; then
        notify-send "System" "$process_name killed successfully"
    fi
fi
