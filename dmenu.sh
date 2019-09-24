#!/usr/bin/sh
# dmenu.sh
# script to do some actions with dmenu, requires dmenu ofc

RESTART_NETWORK_MANAGER="1. restart NetworkManager"
RESTART_DWM="2. restart dwm"
KILL_PROCESS="3. kill process"
CHANGE_KEYBOARD_LAYOUT="4. change keyboard layout"

options="$RESTART_NETWORK_MANAGER\n$RESTART_DWM\n$KILL_PROCESS\n$CHANGE_KEYBOARD_LAYOUT"

result=$(echo -e $options | dmenu -l 10)
echo $result

if [ "$result" == "$RESTART_NETWORK_MANAGER" ]
then
    sudo systemctl restart NetworkManager
elif [ "$result" == "$RESTART_DWM" ]
then
    sudo make install -C ~/workspace/dwm/
    pkill dwm
elif [ "$result" == "$KILL_PROCESS" ]
then
    all_processes=$(ps -eo comm | tail -n +2)
    process_to_kill=`echo -e "$all_processes" | dmenu -i`
    if [ "$process_to_kill" != "" ]
    then
        while [ "`pgrep "$process_to_kill"`" ]; do killall "$process_to_kill"; done
    fi
elif [ "$result" == "$CHANGE_KEYBOARD_LAYOUT" ]
then
    all_layouts=$(localectl list-x11-keymap-layouts)
    layout_to_switch_to=$(echo -e "$all_layouts" | dmenu -i)
    setxkbmap -layout "$layout_to_switch_to"
fi
