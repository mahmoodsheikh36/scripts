#!/bin/bash

# backgrounder.sh - fade transition between wallpapers
# use like this: ./backgrounder.sh ~/wallpaper
# this script is dirty af and i doubt its anywhere close to being efficient

echo using pictures in directory $1
cd $1
image_dir="$1"
images=$(find . -path ./ignore -prune -o -name "*.jpg" -print -o -name "*.jpeg" -print -o -name "*.png" -print | shuf)
image_cache_dir=~/.cache/backgrounder
dimmed_images_count=10
image_count=$(echo $images | wc -w)
screen_size=`xrandr | grep primary | cut -d " " -f4 | cut -d "+" -f1`
image_time=200 # display each image for 200 seconds

if [ ! -z "$2" ]; then
    image_time="$2"
fi

# create cache directory
if [ ! -d "$image_cache_dir" ]; then
    mkdir -p "$image_cache_dir"
fi

generate_dimmed_pictures() {
    for ((d=1; d<=$image_count; d++))
    do
        dim_percentage=0%
        image=$(basename `echo $images | cut -d ' ' -f "$d"`)
        generated_new_images=0
        for ((f=0; f<=$dimmed_images_count; f++))
        do
            dim_percentage="`expr 100 - $f \* $(expr 100 / $dimmed_images_count)`%"
            file_to_save_dimmed_image="${image_cache_dir}/$image-$dim_percentage"
            if [ ! -f $file_to_save_dimmed_image ]; then
                generated_new_images=1
                convert -fill black -resize "$screen_size!" -colorize "$dim_percentage" "$image" "$file_to_save_dimmed_image"
            fi
        done
        if [ $generated_new_images = 1 ]; then
            notify-send -i "${image_dir}/$image" "System Wallpaper Manager" "generated dimmed images for\n$image"
        fi
    done
    notify-send "System Wallpaper Manager" "done generating dimmed images" -t 10
}

while [ true ]
do
    for ((i=1; i<=$image_count; i++))
    do
        image=`basename $(echo $images | cut -d ' ' -f "$i")`

        dim_percentage=100%
        for ((j=0; j<=$dimmed_images_count; j++))
        do
            image_file="${image_cache_dir}/$image-$dim_percentage"
            if [ ! -f $image_file ]; then
                notify-send "System Wallpaper Manager" "regenerating dimmed images"
                generate_dimmed_pictures
            fi
            hsetroot -fill "$image_file" > /dev/null
            dim_percentage="`expr 100 - $(expr $j + 1) \* $(expr 100 / $dimmed_images_count)`%"
            sleep 0.01
        done
        notify-send -i "${image_dir}/$image" "System Wallpaper Manager" "set wallpaper to\n$image" -t 3

        sleep $image_time

        dim_percentage=0%
        image=$(echo $images | cut -d ' ' -f "$i")
        for ((j=0; j<$dimmed_images_count; j++))
        do
            dim_percentage="`expr $(expr $j + 1) \* $(expr 100 / $dimmed_images_count)`%"
            image_file="${image_cache_dir}/$image-$dim_percentage"
            if [ ! -f $image_file ]; then
                notify-esnd "System Wallpaper Manager" "regenerating dimmed images"
                generate_dimmed_pictures
            fi
            hsetroot -fill "$image_file" > /dev/null
            sleep 0.01
        done

    done
done
