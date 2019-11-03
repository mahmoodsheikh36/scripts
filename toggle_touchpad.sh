#!/bin/sh
# requirements: xinput command
# toggles activity of touchpad using `xinput`

dev=`xinput | grep touchpad -i | awk -F 'id=' '{print $2}' | cut -d $'\t' -f1`
echo $dev
if [ `xinput list-props $dev | grep enabled -i | awk '{print $4}'` = 1 ];
then
    xinput disable $dev
    notify-send "disabled touchpad" -t 1000
else
    xinput enable $dev
    notify-send "enabled touchpad" -t 1000
fi
