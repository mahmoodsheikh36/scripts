#!/bin/sh
# backgrounder.sh - fade transition between wallpapers
# use like this: ./backgrounder.sh ~/wallpaper

echo using pictures in directory $1
cd $1
image_dir="$1"
images=$(find . -name "*.jpg" -or -name "*.jpeg" | shuf)
image_cache_dir=~/.cache/backgrounder
dimmed_images_count=5
image_count=$(echo $images | wc -w)

# create cache directory
if [ ! -d "$image_cache_dir" ]; then
    mkdir -p "$image_cache_dir"
fi

generate_dimmed_pictures() {
    for ((i=1; i<=$image_count; i++))
    do
        dim_percentage=0%
        image=$(echo $images | cut -d ' ' -f "$i")
        for ((j=0; j<=$dimmed_images_count; j++))
        do
            file_to_save_dimmed_image="${image_cache_dir}/$image-$dim_percentage"
            if [ ! -f $file_to_save_dimmed_image ]; then
                dim_percentage="`expr 100 - $j \* $(expr 100 / $dimmed_images_count)`%"
                convert -fill black -colorize "$dim_percentage" "$image" "$file_to_save_dimmed_image"
            fi
        done
        notify.sh "generated dimmed images for $image"
    done
}

while [ true ]
do

    for ((i=1; i<=$image_count; i++))
    do
        image=$(echo $images | cut -d ' ' -f "$i")
        echo "require('naughty').notify({title='System Wallpaper', text='set wallpaper to\n`basename $image`', icon='${image_dir}/$image', icon_size=200})" | awesome-client

        dim_percentage=100%
        for ((j=0; j<=$dimmed_images_count; j++))
        do
            image_file="${image_cache_dir}/$image-$dim_percentage"
            echo $image_file
            if [ ! -f $image_file ]; then
                notify.sh "regenerating dimmed images"
                generate_dimmed_pictures
            fi
            hsetroot -cover "$image_file"
            dim_percentage="`expr 100 - $(expr $j + 1) \* $(expr 100 / $dimmed_images_count)`%"
            sleep 0.01
        done

        sleep 200 # display each image for 200 seconds

        dim_percentage=0%
        image=$(echo $images | cut -d ' ' -f "$i")
        for ((j=0; j<$dimmed_images_count; j++))
        do
            dim_percentage="`expr $(expr $j + 1) \* $(expr 100 / $dimmed_images_count)`%"
            image_file="${image_cache_dir}/$image-$dim_percentage"
            echo $image_file
            if [ ! -f $image_file ]; then
                notify.sh "regenerating dimmed images"
                generate_dimmed_pictures
            fi
            hsetroot -cover "$image_file"
            sleep 0.01
        done

    done
done
