#!/usr/bin/sh

st -e tmux new-session \; send-keys "$*; exit" C-m \;
