#!/bin/sh

VOL() {
    size=10
    volume=`pactl list sinks | awk '/^\s*Volume/{print $5}'`
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

LAYOUT() {
    setxkbmap -query | awk '/layout/ {print $2}'
}

DATE() {
    date "+%H:%M:%S %d/%m/%y"
}

WORKSPACES() {
    workspaces=$(bspc query --desktops --names)
    active_workspace=$(bspc query --desktops --names -n)
    text=""
    for workspace in $workspaces; do
        if [ "$workspace" = "$active_workspace" ]; then
            text="${text}%{F#000000}%{B#FFFFFF}$workspace%{F#FFFFFF}%{B#000000} "
        else
            text="${text}%{F#FFFFFF}%{B#000000}$workspace%{F#FFFFFF}%{B#000000} "
        fi
    done
    text="${text}"
    echo "$text"
}

while true; do
    echo "%{l}$(WORKSPACES) %{c}$(LAYOUT) | VOL $(VOL) %{r}DATE $(DATE) %{F-}%{B-}"

    sleep 0.3
done
