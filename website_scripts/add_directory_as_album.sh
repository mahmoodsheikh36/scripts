#!/bin/sh
# adds all mp3 files in current directory as an album, files should be named according to their index

album_id="$1"
artist_ids="$2"
last_file_number="$3"

if [ -z "$album_id" ]; then
    echo enter album id as first argument
    exit 1
fi

if [ -z "$artist_ids" ]; then
    echo enter artist ids of all the songs as second argument
    exit 1
fi

if [ -z "$last_file_number" ]; then
    echo enter the number of the last file, aka the number of the last song in the album
    exit 1
fi

current="01"
while [ $last_file_number -gt $(expr $current - 1) ]; do
    add_album_song.sh $current*.mp3 $album_id $current $artist_ids
    current_num=$(expr $current + 1)
    if [ $current_num -lt 10 ]; then
        current=0$current_num
    else
        current=$current_num
     fi
done
