#!/bin/sh

song_id="$1"
playlist_id="$2"

if [ -z "$song_id" ]; then
    echo please provide the id of the song you want added as the first argument
    exit 1
fi

if [ -z "$playlist_id" ]; then
    echo please provide the id of the playlist you want the song to be added to
    exit 1
fi

BACKEND="10.0.0.55/music/add_song_to_playlist"

curl "$BACKEND?playlist_id=$playlist_id&song_id=$song_id" \
    -F username=mahmooz -F password=mahmooz
