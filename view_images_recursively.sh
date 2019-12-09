#!/bin/sh
# view_images_recursively.sh - find all images and view them in sxiv

dir_to_view=$1
if [ -z "$1" ]; then
    dir_to_view="$PWD"
fi

find "$dir_to_view" -exec file --mime {} \; > /tmp/image_cache
awk '/image/{print $1}' /tmp/image_cache | rev | cut -c2- | rev | xargs -d '\n' sxiv 
