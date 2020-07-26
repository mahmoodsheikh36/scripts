#!/usr/bin/sh


program=$(pacman -Ssq | rofi -dmenu -p 'program')
[ -z "$program" ] && exit
alacritty_with_cmd.sh sudo pacman --noconfirm -S $program
notify-send -t 20000 "installed $program"
