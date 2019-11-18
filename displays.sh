#!/bin/sh

# incomplete script to help with xrandr

outputs=`xrandr | grep " connected" | cut -d " " -f1`
chosen_output=`echo -n "$outputs" | rofi -dmenu -i`
primary=`xrandr | grep "primary" | cut -d " " -f1`

available_options="left-of $primary\nright-of $primary\nabove\nbelow\nsame-as"
