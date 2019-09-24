#!/bin/sh
# acpi_listen_script.sh

# use like this: acpi_listen | acpi_listen_script.sh
# requires acpi_listen, owned by acpid in Pacman repos

while read line
do
    # headphones
    if [[ $line == *"headphone"* ]]; then
        if [[ $line == *" plug"* ]]; then
            echo "headphones plugged! woo!"
            # playerctl play
        fi
        if [[ $line == *"unplug"* ]]; then
            echo 'headphones unplugged :('
            # amixer set Master 0
            # playerctl pause
        fi
    fi

    # screen lid
    if [[ "$line" == *"LID"* ]]; then
        if [[ "$line" == *"close"* ]]; then
            echo "lid closed"
            i3lock -i ~/pictures/lockscreen.png
        fi
        if [[ "$line" == *"open"* ]]; then
            echo "lid opened"
            sudo systemctl restart NetworkManager
        fi
    fi
done < "${1:-/dev/stdin}"
