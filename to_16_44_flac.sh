#!/bin/sh
# requires: ffmpeg
for f in *.flac;
do
    echo "Processing $f"
    ffmpeg -i "$f" -sample_fmt s16 -ar 44100 "${f%.flac}-16.flac"
done
