#!/bin/sh

if [ -z "$1" ]; then
    echo please enter song id as first argument
    exit 1
fi

song_id="$1"
