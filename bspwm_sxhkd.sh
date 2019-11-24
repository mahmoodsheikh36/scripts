#!/bin/sh

start_sxhkd() {
    echo hi1 >> ~/test
    export BSPWM_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/bspwm"
    killall sxhkd
    echo hi2 >> ~/test
    config_file=~/.cache/sxhkdrc
    if [ -f "$config_file" ]; then
        rm "$config_file"
    fi
    echo hey >> ~/test
    cp ~/.config/sxhkd/sxhkdrc "$config_file"
    echo hi >> ~/test
    cat "$BSPWM_CONFIG/sxhkdrc" >> "$config_file"
    echo $config_file >> ~/test
    sxhkd -c "$config_file" &
}
start_sxhkd
