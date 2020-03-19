#!/bin/sh

BACKEND="10.0.0.54/music/add_album"

if [ -z "$1" ]; then
    echo enter album name as first argument
    exit 1
fi

if [ -z "$2" ]; then
    echo enter artist ids seperated by comma as second argument
    exit 1
fi

if [ -z "$3" ]; then
    echo enter image path as third argument
    exit 1
fi

if [ -z "$4" ]; then
    echo enter the year of the album as fourth argument
    exit 1
fi

album_name="$1"
artist_ids="$2"
image_file_path="$3"
year="$4"

urlencode () {
    python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.stdin.read()))"
}

curl -X POST "$BACKEND?album_name=$(echo -n "$album_name" | urlencode)&artist_ids=$(echo $artist_ids | urlencode)&year=$year" \
    -F "image=@$image_file_path" \
    -F 'username=mahmooz' -F 'password=mahmooz' | jq
