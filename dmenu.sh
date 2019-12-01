#!/bin/sh

colors_file="${HOME}/.cache/wal/colors.sh"
if [ -f "$colors_file" ]; then
	. "$colors_file"
	dmenu -nb "$color0" -nf "$color15" -sb "$color1" -sf "$color15" "$@" < /dev/stdin
else
	dmenu "$@" < /dev/stdin
fi
