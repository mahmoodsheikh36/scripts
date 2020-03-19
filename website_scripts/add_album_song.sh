#!/bin/sh

if [ -z "$1" ]; then
    echo "please enter path to audio file as first argument"
    exit 1
fi

if [ -z "$2" ]; then
    echo please enter the album\'s id as second argument
    exit 1
fi

if [ -z "$3" ]; then
    echo enter the song\'s index in the album as the third argument
    exit 1
fi

if [ -z "$4" ]; then
    echo enter the artist ids seperated by comma as fourth argument
    exit 1
fi

audio_file_path="$1"
album_id="$2"
index_in_album="$3"
artist_ids="$4"
name="$5"
backend="10.0.0.54/music/add_song_to_album"

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
if [ -z "$name" ]; then
    name=$(echo "$ffmpeg_output" | grep -m1 -i 'title' | tr -s ' ' | cut -d ' ' -f4-)
fi

time="$(echo "$ffmpeg_output" | grep Duration | cut -d ' ' -f4 | tr -d ',')"
minutes="$(echo "$time" | cut -d ':' -f2)"
seconds="$(echo "$time" | cut -d ':' -f3 | cut -d '.' -f1)"
duration=$(expr $minutes \* 60 + $seconds)

bitrate="$(mediainfo "$audio_file_path" | grep 'Bit rate\s*:' | tr -s ' ' | cut -d ' ' -f4)"

urlencode () {
    python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.stdin.read()))"
}

curl -s -X POST "$backend?index_in_album=$index_in_album&album_id=$album_id&name=$(echo -n "$name" | urlencode)&bitrate=$bitrate&duration=$duration&artist_ids=$artist_ids" \
    -F 'username=mahmooz' -F 'password=mahmooz' -F "audio=@\"$audio_file_path\"" | jq
