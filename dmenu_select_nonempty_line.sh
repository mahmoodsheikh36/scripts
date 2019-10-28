#!/bin/sh
# dmenu_select_nonempty_line.sh
# reads stdin and pipes all nonempty lines to dmenu and returns dmenu result

in=""
while read line; do
    in+="$line\n"
done < "${1:-/dev/stdin}"
echo -en "$in" | grep "^$" -v | dmenu -l 10 | tr -d "\n"
