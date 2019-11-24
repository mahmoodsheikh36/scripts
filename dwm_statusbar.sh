#!/bin/sh


while true;
do
    time=`date "+%H:%M:%S %d/%m/%y"`
    statusbar_text="$time"
    volume=`amixer get Master | tail -1 | cut -d "[" -f2 | cut -d "%" -f1`

    xsetroot -name "VOL $volume% | DATE $statusbar_text"
    sleep 0.6
done
