#!/bin/sh
# lyrics.sh

should_open_lyrics_file=1
if [ ! -z $1 ]; then
    should_open_lyrics_file=$1
fi

song=`cat ~/.cache/spotify_dmenu/lib_tracks_names | dmenu -p song -i -l 15`
if [ "$song" = "" ]; then
    exit 0
fi
lyrics_file="$HOME/media/lyrics/$song"
if [ ! -f "$lyrics_file" ]; then
    notify-send "fetching lyrics for '$song'"
    lyrics=`clyrics "$song"`
    if [ "$lyrics" = "" ]; then
        notify-send "couldn't find lyrics for '$song'"
    else
        echo "$lyrics" > "$lyrics_file"
        if [ $should_open_lyrics_file -eq 1 ]; then
            notify-send "opened lyrics buffer"
            st -e zsh -i -c "vim \"$lyrics_file\""
        else
            notify-send "lyrics fetched for '$song'"
        fi
    fi
else
    if [ $should_open_lyrics_file -eq 1 ]; then
        notify-send "opened lyrics buffer"
        st -e zsh -i -c "vim \"$lyrics_file\""
    else
        notify-send "lyrics already present"
    fi
fi
