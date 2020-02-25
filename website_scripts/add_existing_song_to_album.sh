#!/bin/sh

album_id="$1"
song_id="$2"
index_in_album="$3"

if [ -z "$album_id" ]; then
    echo please enter the album\'s id as the first argument
    exit 1
fi

if [ -z "$song_id" ]; then
    echo please enter the song\'s id as the second argument
    exit 1
fi

if [ -z "$index_in_album" ]; then
    echo please enter the song\'s index in the album as third argument
    exit 1
fi

urlencode () {
    python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.stdin.read()))"
}

curl -s -X POST "10.0.0.55/music/add_existing_song_to_album?song_id=$song_id&album_id=$album_id&index_in_album=$index_in_album" -F 'username=mahmooz' -F 'password=mahmooz' | jq
