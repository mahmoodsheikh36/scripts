#!/bin/sh
# generate_colorful_image - generate an image with randomly colored pixels
# generates it for primary screen geometry

primary_screen_geometry=$(xrandr | awk '/primary/{print $4}' | cut -d '+' -f1)
width=$(echo $primary_screen_geometry | cut -d 'x' -f1)
height=$(echo $primary_screen_geometry | cut -d 'x' -f2)

colors="#000000\n#ffffff\n#ff0000\n#00ff00\n#0000ff" # hardcoded colors, whatever
colors_count=$(echo $colors | wc -l)
image_file="image.png"

# generates color files 1x1 pixel size
generate_color_files() {
    for color in $(echo $colors); do
        echo "generated color $color"
        convert -size 1x1 xc:"$color" "$color".png
    done
}

# generates horizontal line of pixels with random color for each pixel
generate_line() {
    line_num=$1
    i=0
    first_pixel=true
    while [ $i -lt $width ]; do
        echo "generating pixel $i of line $line_num"
        color_index=$(shuf -n 1 -i "1-$colors_count" -r)
        color=$(echo "$colors" | sed -n "${color_index}p")
        color_file="$color.png"
        cp "$color_file" "pixel_$i"
        i=$(expr 1 + $i)
    done
    convert pixel_* +append "line$line_num.png"
}

generate_color_files

# generates image
generate_image() {
    j=0
    while [ $j -lt $height ]; do
        generate_line $j
        echo generated line $j
        j=$(expr $j + 1)
    done

    convert line*.png -append "$image_file"
    echo "done, generated image"
}

generate_image

# clean shit up - or no need xd
