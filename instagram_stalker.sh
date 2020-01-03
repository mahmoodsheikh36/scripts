#!/bin/sh

socks5_proxy="125.227.69.217:1002"
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

get_user_agent() {
    shuf -n1 ~/workspace/scripts/user-agents.txt
}

get_user_page_content() {
    curl -H "user-agent: $(get_user_agent)" -s --socks5-hostname "$socks5_proxy" "$user_url"
}

page_content="$(get_user_page_content)"
echo "$page_content" | grep -o '<meta property="og:[a-z]\+" content=".*/>' > /tmp/new_data
echo "$page_content" | grep -o 'graphql":.*,"edge_saved_media' >> /tmp/new_data

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
