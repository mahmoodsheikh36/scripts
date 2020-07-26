#!/usr/bin/sh

[ -z "$*" ] || alacritty -e tmux new-session \; send-keys "$*; exit" C-m \;
