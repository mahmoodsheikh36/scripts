#!/bin/sh

if [ -z "$1" ]; then
    echo "please enter path to audio file as first argument"
    exit 1
fi

audio_file_path="$1"
music_library=$(jq --raw-output .library_path config.json)

if [ ! -f "$audio_file_path" ]; then
    echo first argument is not a path to a file
    exit 1
fi

audio_mimetype=false
case "$(file --mime-type "$audio_file_path")" in *audio/*) audio_mimetype=true;; esac
if ! $audio_mimetype; then
    echo given argument is a path to file but doesnt contain audio
    exit 1
fi

if [ ! -d "$music_library" ]; then
    mkdir "$music_library"
    echo created music library directory
fi

ffmpeg_output=$(ffmpeg -i "$audio_file_path" 2>&1)
artist=$(echo "$ffmpeg_output" | grep -m1 'artist' | tr -s ' ' | cut -d ' ' -f4-)
name=$(echo "$ffmpeg_output" | grep -m1 'title' | tr -s ' ' | cut -d ' ' -f4-)
album=$(echo "$ffmpeg_output" | grep -m1 'album' | tr -s ' ' | cut -d ' ' -f4-)
lyrics=$(echo "$ffmpeg_output" | sed -n '/^\s*:.*/p' | tr -s ' ' | cut -d ' ' -f3- | less)

if [ ! -d "$music_library/audio" ]; then
    mkdir "$music_library/audio"
    echo created audio directory
fi
if [ ! -f "$music_library/data.sqlite" ]; then
    sqlite3 "$music_library/data.sqlite" "$(cat init_db.sql)"
    echo created sqlite database
fi

audio_file_name="$(echo "$audio_file_path" | rev | cut -d '/' -f1 | rev)"
mv "$audio_file_path" "$music_library/audio/"
new_file_path="$music_library/audio/$audio_file_name"

sqlite3 "$music_library/data.sqlite" "insert into songs (name, artist, file_path) VALUES(\"$(echo "$name" | sed 's/"/\"\"/g')\", \"$artist\", \"$new_file_path\")"

echo added song \"$name\" by \"$artist\" to library
