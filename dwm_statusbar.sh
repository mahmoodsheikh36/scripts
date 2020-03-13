#!/bin/sh
# dwm_statusbar.sh - statusbar script for suckless's dwm

VOL() {
    size=10
    volume=$(pactl list sinks | awk '/^\s*Volume/{print $5}')
    percentage=$(echo $volume | tr -d "%")
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

# acpi is slow, takes like 1.5 seconds to finish :/
BATTERY() {
    acpi | awk '{print toupper($3), $4, $5, $6, $7}' | sed 's/,//; s/ \+$//'
}

LAYOUT() {
    setxkbmap -query | awk '/layout/ {print $2}'
}

STORAGE() {
    df -h | awk '/\/$/ {print $3 " / " $2}'
}

MEM() {
    free -h | awk '/Mem/ {print $3 " / " $2}'
}

date=$(date "+%H:%M:%S %d/%m/%y")
echo "$(LAYOUT) | MEM $(MEM) | STORAGE $(STORAGE) | VOL $(VOL) | DATE $date"
