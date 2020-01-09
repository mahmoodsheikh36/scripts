#!/bin/sh

if [ -z "$1" ]; then
    echo please give me path to image as first arguemnt
    exit 1
fi
if [ -z "$2" ]; then
    echo please give me path to output directory as second argument
    exit 1
fi
image="$1"
output_dir="$2"
image_dir="$PWD"
if [ ! -z "$3" ]; then image_dir="$3"; fi
if [ ! -d "$output_dir" ]; then mkdir "$output_dir"; fi

mkdir "$output_dir/tmp/"
cp "$image" "$output_dir/tmp/"

face_recognition --show-distance true --cpus $(nproc) "$output_dir/tmp/" "$image_dir" > "$output_dir/recognized"

rm -r "$output_dir/tmp/"
