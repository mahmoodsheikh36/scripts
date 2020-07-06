#!/usr/bin/sh

dmenu -l 20 -w 500 -x 700 -y 200 -i $@ < "${1:-/dev/stdin}"
