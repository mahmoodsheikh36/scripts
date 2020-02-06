#!/bin/sh

if [ -z "$1" ]; then
    echo "please enter path to album directory as first argument"
    exit 1
fi

album_dir_path="$1"
music_library=/home/mahmooz/media/music

echo "adding all songs in $album_dir_path"

find "$album_dir_path" -type f -exec add_song.sh {} \;
