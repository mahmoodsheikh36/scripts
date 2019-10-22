#!/bin/sh
notified=0
while [ true ]
do
    battery=`acpi | cut -d " " -f4 | cut -d "%" -f1`
    echo $battery
    if [ $battery -lt 20 ]; then
        echo hi
        if [ $notified = 0 ]; then
            echo hey
            notify-send -t 10000 "System" "Battery is below 20%"
            notified=1
        fi
    else
        notified=0
    fi
    sleep 5
done
