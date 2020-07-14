#!/usr/bin/sh

[ -z "$*" ] || st -e tmux new-session \; send-keys "$*; exit" C-m \;
