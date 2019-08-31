#!/bin/sh
# acpi_listen_script.sh

# use like this: acpi_listen | acpi_listen_script.sh
# requires acpi_listen, owned by acpid in Pacman repos

while read line
do
    if [[ $line == *"headphone"* ]]; then
        if [[ $line == *" plug"* ]]; then
            echo "headphones plugged! woo!"
            # playerctl play
        fi
        if [[ $line == *"unplug"* ]]; then
            echo 'headphones unplugged :('
            amixer set Master 0
            playerctl pause
        fi
    fi
done < "${1:-/dev/stdin}"
