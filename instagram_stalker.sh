#!/bin/sh

user_url="$1"
if [ -z "$user_url" ]; then
    echo please enter user url as first argument
    exit 1
fi
output_dir=~/media/2/instagram
if [ ! -z "$2" ]; then
    output_dir="$2"
fi
if [ ! -d "$output_dir" ]; then
    mkdir "$output_dir"
fi

get_date() {
    date "+%H:%M:%S %d_%m_%y"
}

curl -s "$user_url" | grep -o '<meta property="og:[a-z]\+" content=".*/>' > /tmp/new_data

save_new_data() {
    date="$(get_date)"
    new_data_file="$output_dir/$date"
    echo "$date" > "$new_data_file"
    cat /tmp/new_data >> "$new_data_file"
    echo "$new_data_file" > "$output_dir/last_data_file"
}

if [ -f "$output_dir/last_data_file" ]; then
    last_data_file=$(cat "$output_dir/last_data_file")
fi
if [ ! -z "$last_data_file" ]; then
    if [ ! "$(cat "$last_data_file" | tail +2)" = "$(cat /tmp/new_data)" ]; then
        save_new_data
    fi
else
    save_new_data
fi
