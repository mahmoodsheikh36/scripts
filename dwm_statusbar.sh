#!/bin/sh
# dwm_statusbar.sh - statusbar script for suckless's dwm

VOL() {
    size=10
    volume=$(amixer get Master | awk '/%/ {print $4}' | tr -d '[]')
    percentage=$(echo $volume | tr -d "%")
    i=1
    volume_text="["
    while [ ! $i -gt $size ]; do
        if [ $(( percentage + 2 )) -gt $(( ( 100 / $size ) * $i )) ]; then
            volume_text="${volume_text}#"
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

MUSIC() {
    music_daemon_cmd.sh current; echo -n ' '; music_daemon_cmd.sh progress
}

date=$(date "+%H:%M:%S %d/%m/%y")
#echo "$(LAYOUT) | $(MUSIC) | MEM $(MEM) | STORAGE $(STORAGE) | VOL $(VOL) | DATE $date"
echo "$(LAYOUT) | $(MUSIC) | VOL $(VOL) | DATE $date"
