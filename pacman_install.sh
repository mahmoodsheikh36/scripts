#!/bin/sh
# pacman_install.sh

program_to_install=$(yay -Ssq | rofi -show -dmenu -p install)

program_is_already_installed=0
pacman -Q | grep "$program_to_install" && program_is_already_installed=1
