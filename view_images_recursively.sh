#!/bin/sh
# view_images_recursively.sh - find all images and view them in sxiv

dir_to_view=$1
if [ -z "$1" ]; then
    dir_to_view="$PWD"
fi

find "$dir_to_view" -exec file --mime {} \; > /tmp/image_cache
grep 'image/[a-z]\+;' /tmp/image_cache | cut -d ':' -f1 | xargs -d '\n' sxiv
