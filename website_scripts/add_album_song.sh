#!/bin/sh

if [ -z "$1" ]; then
    echo "please enter path to audio file as first argument"
    exit 1
fi

audio_file_path="$1"
image_file_path="$2"
#backend="https://mahmoodsheikh.com/music/add_song"
backend="10.0.0.55/music/add_album_song"

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
artist=$(echo "$ffmpeg_output" | grep -i -m1 '\sartist\s' | tr -s ' ' | cut -d ' ' -f4-)
album_artist=$(echo "$ffmpeg_output" | grep -i -m1 '\salbum_artist\s' | tr -s ' ' | cut -d ' ' -f4-)
name=$(echo "$ffmpeg_output" | grep -i -m1 '\stitle\s' | tr -s ' ' | cut -d ' ' -f4-)
album=$(echo "$ffmpeg_output" | grep -i -m1 '\salbum\s' | tr -s ' ' | cut -d ' ' -f4-)
lyrics=$(echo "$ffmpeg_output" | sed -n '/^\s*:.*/p' | tr -s ' ' | cut -d ' ' -f3- | sed 's/;/%3B/g')

if [ -z "$album_artist" ]; then
    echo no album_artist, defaulting to artist: $artist
    album_artist=$artist
fi

time="$(echo "$ffmpeg_output" | grep Duration | cut -d ' ' -f4 | tr -d ',')"
minutes="$(echo "$time" | cut -d ':' -f2)"
seconds="$(echo "$time" | cut -d ':' -f3 | cut -d '.' -f1)"
duration=$(expr $minutes \* 60 + $seconds)

echo "\n"trying to add song \'$name\' by \'$artist\'....

if [ -z "$image_file_path" ] ; then
    if [ -f /tmp/image.png ]; then
        rm /tmp/image.png
    fi
    2>/dev/null 1>/dev/null ffmpeg -y -i "$audio_file_path" -c:a copy /tmp/image.png
    if [ ! -f /tmp/image.png ]; then
        echo "audio file contains no video or image"
        exit 1
    fi
    image_file_path=/tmp/image.png
fi

if [ -z "$lyrics" ]; then
    curl -X POST "$backend" --form-string 'username=mahmooz' --form-string 'password=mahmooz' -F "audio=@$audio_file_path" --form-string album="$album" --form-string duration=$duration --form-string artist="$artist" --form-string album_artist="$album_artist" --form-string name="$name" --form-string "audio_file_name=$audio_file_path" --form-string "image_file_name=$image_file_path" -F "image=@$image_file_path"
else
    curl -X POST "$backend" --form-string 'username=mahmooz' --form-string 'password=mahmooz' -F "audio=@$audio_file_path" --form-string album="$album" --form-string duration=$duration --form-string artist="$artist" --form-string album_artist="$album_artist" --form-string name="$name" --form-string "audio_file_name=$audio_file_path" --form-string "image_file_name=$image_file_path" -F "image=@$image_file_path" --form-string "lyrics=$lyrics"
fi
