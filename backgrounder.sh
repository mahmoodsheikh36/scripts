#!/bin/sh
# backgrounder.sh - fade transition between wallpapers
# use like this: ./backgrounder.sh ~/wallpaper

echo using pictures in directory $1
cd $1
images=$(find . -name "*.jpg" -or -name "*.jpeg")

while [ true ]
do
    image_count=$(echo $images | wc -w)
    for ((i=1; i<=image_count; i++))
    do
        current_image=$(echo $images | cut -d ' ' -f "$i")

        for j in {1..5}
        do
            dim_percentage="`expr 100 - $j \* 20`%"
            convert -fill black -colorize "$dim_percentage" "$current_image" "/tmp/$current_image"
            feh --bg-fill "/tmp/$current_image"
            echo "dim $current_image by $dim_percentage"
            sleep 0.01
        done

        sleep 30 # display each picture for 100 seconds

        # start dimming current picture
        for j in {1..5}
        do
            dim_percentage="`expr $j \* 20`%"
            convert -fill black -colorize "$dim_percentage" "$current_image" "/tmp/$current_image"
            feh --bg-fill "/tmp/$current_image"
            echo "dim $current_image by $dim_percentage"
            sleep 0.01
        done

    done
    echo ih
done
