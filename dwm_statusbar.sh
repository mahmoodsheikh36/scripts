#!/bin/sh

VOL() {
    size=10
    volume=`pactl list sinks | grep Volume | head -1 | awk '{print $5}'`
    percentage=`echo $volume | tr -d "%"`
    i=1
    volume_text="["
    while [ ! $i -gt $size ]; do
        if [ $(( percentage + 2 )) -gt $(( ( 100 / $size ) * $i )) ]; then
            volume_text="$volume_text#"
        else
            volume_text="$volume_text-"
        fi
        i=$(( i + 1 ))
    done
    volume_text="${volume_text}] ($volume)"
    echo "$volume_text"
}

while true;
do
    date=`date "+%H:%M:%S %d/%m/%y"`

    xsetroot -name "VOL `VOL` | DATE $date"
    sleep 0.4
done
