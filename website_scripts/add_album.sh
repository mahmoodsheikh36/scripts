#!/bin/sh

BACKEND="10.0.0.55/music/add_album"

if [ -z "$1" ]; then
    echo enter album name as first argument
    exit 1
fi

if [ -z "$2" ]; then
    echo enter artist id as second argument
    exit 1
fi

if [ -z "$3" ]; then
    echo enter image path as third argument
    exit 1
fi

album_name="$1"
artist_id="$2"
image_file_path="$3"

urlencode () {
    python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.stdin.read()))"
}

curl -X POST "$BACKEND?album_name=$(echo -n "$album_name" | urlencode)&artist_id=$artist_id" \
    -F "image=@$image_file_path" -F 'username=mahmooz' -F 'password=mahmooz' | jq
