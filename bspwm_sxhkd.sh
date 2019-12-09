#!/bin/sh

start_sxhkd() {
    export BSPWM_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/bspwm"
    killall sxhkd
    config_file=~/.cache/sxhkdrc
    if [ -f "$config_file" ]; then
        rm "$config_file"
    fi
    cp ~/.config/sxhkd/sxhkdrc "$config_file"
    cat "$BSPWM_CONFIG/sxhkdrc" >> "$config_file"
    echo $config_file >> ~/test
    sxhkd -c "$config_file" &
}
start_sxhkd
