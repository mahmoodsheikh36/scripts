#!/bin/sh
# kill a running process using dmenu

process_name=`ps -e | awk '{ print $4 }' | sort -u | dmenu -l 10 -i -p "process"`
if [ ! -z $process_name ]; then
    for process in $(ps -e | grep " $process_name$" | awk '{ print $1 }');
    do
        if [ ! -z $process ]; then
            kill -9 $process
        fi
    done
    if [ -z "$(ps -e | grep " $process_name$")" ]; then
        notify-send "System" "$process_name killed successfully"
    fi
fi
