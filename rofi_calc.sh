#!/bin/sh
# a calculator using qalc and rofi

msg="enter math expr to calc"
while [ true ]; do
    expr=``
    expr=`rofi -dmenu -mesg "$msg" -p expression`
    if [ -z "$expr" ]; then
        exit 0
    fi
    msg=`qalc "$expr"`
done
