#!/bin/sh
# dmenu_run.sh - dmenu launcher with history

cache_file=~/media/script_data/program_launcher
all_programs="$(ls /usr/bin)\n$(ls /usr/local/bin)"
if [ -f "$cache_file" ]; then
    cached_programs="$(sort -k 2 -r "$cache_file" | cut -d ' ' -f1)"
    for program in $all_programs; do
        is_program_cached=false
        for cached_program in $cached_programs; do
            if [ "$cached_program" = "$program" ]; then
                is_program_cached=true
            fi
        done
        if ! $is_program_cached; then
            other_programs="$program\n$other_programs"
        fi
    done
    sorted_programs="$cached_programs\n$other_programs"
else
    sorted_programs="$all_programs"
fi
program=$(echo "$sorted_programs" | dmenu -r -i -p "program")

if [ -z "$program" ]; then exit; fi

if [ -f "$cache_file" ]; then
    grep "^$program " "$cache_file"
    if [ $? -eq 1 ]; then
        echo "$program 0" >> "$cache_file"
    fi
    launch_count=$(awk "/^$program /{print \$2}" "$cache_file")
    sed -i "s/^$program [0-9]*/$program $(expr $launch_count + 1)/" "$cache_file"
else
    echo "$program 1" > "$cache_file"
fi
$program &
notify-send "launched $program"
