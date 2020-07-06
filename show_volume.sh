#!/usr/bin/sh

prev_pid_file=$HOME/.cache/show_volume_progress_pid
if [ -f "$prev_pid_file" ]; then
    prev_pid=$(cat $prev_pid_file)
    [ ! -z $prev_pid ] && kill $prev_pid 2>/dev/null
    rm "$prev_pid_file"
fi

volume_percentage=$(pactl list sinks | awk '/^\sVolume:/ {print $5}' | tr -d '%')

timeout 4 sh -c "(echo -n '^fn(Noto Color Emoji-20)🔊^fn(Hack-20)';\
    progress.py -l 20 -p $volume_percentage; echo ' $volume_percentage%') |\
    dzen2 -p -x 100 -y 100 -w 470 -bg '#000000' -fg '#ffffff' -fn 'Hack-20'" &

echo $! > "$prev_pid_file"

wait
