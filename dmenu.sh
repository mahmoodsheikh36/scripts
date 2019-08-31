#!/usr/bin/sh
# dmenu.sh
# script to do some actions with dmenu, requires dmenu ofc

options="restart NetworkManager"

result=$(echo $options | dmenu -l 10)
if [ "$result" == "restart NetworkManager" ]
then
    echo "restarting NetworkManager"
    sudo systemctl restart NetworkManager
fi
