#!/usr/bin/sh

url=$(echo -n "$1" | cut -d '?' -f1 | tr -d '\n')
curl -L -o /tmp/image "$url"
sxiv /tmp/image
