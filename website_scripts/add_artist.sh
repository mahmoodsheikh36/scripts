#!/bin/sh

artist_name="$1"

if [ -z "$artist_name" ]; then
    echo please provide the artist name as first argument   
    exit 1
fi

urlencode () {
    python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.stdin.read()))"
}

curl -s -X POST "10.0.0.55/music/add_artist?name=$(echo -n "$artist_name" | urlencode)" -F 'username=mahmooz' -F 'password=mahmooz' | jq
