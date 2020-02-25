#!/bin/sh

if [ -z "$1" ]; then
    echo "please enter path to audio file as first argument"
    exit 1
fi

if [ -z "$2" ]; then
    echo enter artist ids seperated by comma as last argument, example: '5,1,10'
    exit 1
fi

if [ -z "$3" ]; then
    echo enter year as third argument
    exit 1
fi

audio_file_path="$1"
image_file_path="$4"
artist_ids="$2"
year="$3"
backend="10.0.0.55/music/add_single_song"

if [ ! -f "$audio_file_path" ]; then
    echo first argument \'"$1"\' is not a path to a file
    exit 1
fi

audio_mimetype=false
case "$(mimetype "$audio_file_path")" in *audio/*) audio_mimetype=true;; esac
if ! $audio_mimetype; then
    echo given argument is a path to file but doesnt contain audio
    exit 1
fi

ffmpeg_output=$(ffmpeg -i "$audio_file_path" 2>&1)
artist=$(echo "$ffmpeg_output" | grep -m1 '\sartist' | tr -s ' ' | cut -d ' ' -f4-)
name=$(echo "$ffmpeg_output" | grep -m1 'title' | tr -s ' ' | cut -d ' ' -f4-)

time="$(echo "$ffmpeg_output" | grep Duration | cut -d ' ' -f4 | tr -d ',')"
minutes="$(echo "$time" | cut -d ':' -f2)"
seconds="$(echo "$time" | cut -d ':' -f3 | cut -d '.' -f1)"
duration=$(expr $minutes \* 60 + $seconds)

bitrate="$(mediainfo "$audio_file_path" | grep 'Bit rate\s*:' | tr -s ' ' | cut -d ' ' -f4)"

if [ -z "$image_file_path" ] ; then
    if [ -f /tmp/image.png ]; then
        rm /tmp/image.png
    fi
    2>/dev/null 1>/dev/null ffmpeg -y -i "$audio_file_path" -c:a copy /tmp/image.png
    if [ ! -f /tmp/image.png ]; then
        echo audio file contains no video or image
        exit 1
    fi
    image_file_path=/tmp/image.png
fi

urlencode () {
    python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.stdin.read()))"
}

curl -s -X POST "$backend?artist_ids=$artist_ids&name=$(echo -n "$name" | urlencode)&bitrate=$bitrate&duration=$duration&year=$year" \
    -F "audio=@$audio_file_path" -F "image=@$image_file_path" \
    -F username=mahmooz -F password=mahmooz | jq
