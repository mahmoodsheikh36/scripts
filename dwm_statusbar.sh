#!/bin/sh


while true;
do
    time=`date "+%H:%M:%S"`
    statusbar_text="$time"
    # volume=`amixer get Speaker -c 1 | tail -1 | cut -d "[" -f2 | cut -d "%" -f1`

    xsetroot -name "$statusbar_text"
    sleep 0.5
done
