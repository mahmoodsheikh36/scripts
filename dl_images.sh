#!/usr/bin/sh

mkdir /tmp/images 2>/dev/null
cd /tmp/images

IFS='
'

while read line; do
    curl -s -O "$line" &
done < "${1:-/dev/stdin}"

wait
