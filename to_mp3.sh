#!/bin/sh
# requires: ffmpeg
for f in *.flac;
do
    echo "Processing $f"
    mkdir '320k'
    ffmpeg -i "$f" -ab 320k "320k/${f%.flac}.mp3"
done
