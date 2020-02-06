#!/bin/sh

BACKEND="localhost/music/create_playlist"

playlist_name="$1"
image_file_path="$2"

if [ -z "$playlist_name" ]; then
    echo please enter playlist name as first argument
    exit 1
fi

if [ -z "$image_file_path" ]; then
    echo please enter image file path as second argument
    exit 1
fi

curl -X POST "$BACKEND?name=$(echo "$playlist_name" | sed 's/ /%20/g')" \
    --form-string username=mahmooz \
    --form-string password=mahmooz \
    -F "image=@$image_file_path" \
    --form-string "image_file_name=$image_file_path"
