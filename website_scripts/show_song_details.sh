#!/bin/sh
audio_file_path="$1"

ffmpeg_output=$(ffmpeg -i "$audio_file_path" -hide_banner 2>&1)
artist=$(echo "$ffmpeg_output" | grep -i -m1 '\sartist\s' | tr -s ' ' | cut -d ' ' -f4-)
album_artist=$(echo "$ffmpeg_output" | grep -i -m1 '\salbum_artist\s' | tr -s ' ' | cut -d ' ' -f4-)
name=$(echo "$ffmpeg_output" | grep -i -m1 '\stitle\s' | tr -s ' ' | cut -d ' ' -f4-)
album=$(echo "$ffmpeg_output" | grep -i -m1 '\salbum\s' | tr -s ' ' | cut -d ' ' -f4-)
lyrics=$(echo "$ffmpeg_output" | sed -n '/^\s*:.*/p' | tr -s ' ' | cut -d ' ' -f3- | sed 's/;/%3B/g')
bitrate=$(echo "$ffmpeg_output" | awk '/Stream #0:0/ {print $(NF-1), $NF}')

time="$(echo "$ffmpeg_output" | grep Duration | cut -d ' ' -f4 | tr -d ',')"
minutes="$(echo "$time" | cut -d ':' -f2)"
seconds="$(echo "$time" | cut -d ':' -f3 | cut -d '.' -f1)"
duration=$(expr $minutes \* 60 + $seconds)

mimetype "$audio_file_path"
echo artist: $artist
echo name: $name
echo album_artist: $album_artist
echo album: $album
echo duration: $duration
echo bitrate: $bitrate
echo lyrics: $(echo "$lyrics" | head -1)....
echo "$ffmpeg_output"
