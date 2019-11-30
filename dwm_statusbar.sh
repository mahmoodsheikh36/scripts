#!/bin/sh


while true;
do
    time=`date "+%H:%M:%S %d/%m/%y"`
    statusbar_text="$time"
    volume=`pactl list sinks | grep Volume | head -1 | awk '{print $5}'`

    xsetroot -name "VOL $volume | DATE $statusbar_text"
    sleep 0.6
done
