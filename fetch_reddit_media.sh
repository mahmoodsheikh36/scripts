#!/bin/sh
# fetch_reddit_media.sh - download images and videos from reddit

subreddits_file="$HOME/workspace/scripts/subreddits.txt"
download_dir="$HOME/media/reddit"
log_file="$HOME/media/script_data/fetch_reddit_media_logs/log_$(date | tr " " "_")"
cache_file="$HOME/media/script_data/fetch_reddit_media.sh"
if [ ! -z "$1" ]; then
    subreddits_file="$1"
fi
if [ ! -z "$2" ]; then
    download_dir="$2"
fi
if [ ! -z "$3" ]; then
    log_file="$3"
fi
if [ ! -z "$4" ]; then
    cache_file="$4"
fi

if [ ! -f "$cache_file" ]; then
    touch "$cache_file"
fi
if [ ! -d "$download_dir" ]; then
    mkdir -p "$download_dir"
fi
cd "$download_dir"
echo $(date) logging to "$log_file"
echo START $(date) >> "$log_file"

get_subreddits() {
    grep "^/r/" "$subreddits_file" | sort -u | awk '{print "https://www.reddit.com" $0 ".rss"}'
}

fetch_rss() {
    get_subreddits | tr ' ' '\n' | while read subreddit_url; do
        echo hi
        curl "$subreddit_url" -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:71.0) Gecko/20100101 Firefox/71.0" 2>/dev/null | grep -o "https://\(i\.\|\)\(gfycat\|redd\|imgur\)\.\(it\|com\)/[a-zA-Z0-9]*\(\.\(gif\|jpg\|png\)\|\)"
        echo "fetched rss feed for $subreddit_url" >> "$log_file"
    done
}

images_downloaded=0
videos_downloaded=0
for file_url in $(fetch_rss); do
    if [ -z "$(grep "$file_url" "$cache_file")" ]; then
        case "$file_url" in
            *.jpg|*.png|*.gif)
                curl -O "$file_url" 2>/dev/null
                if [ $(echo $?) = 0 ]; then
                    echo $(date) downloaded image $file_url >> "$log_file"
                    echo "$file_url" >> "$cache_file"
                    images_downloaded=$(expr $images_downloaded + 1)
                else
                    echo $(date) failed to download image $file_url >> "$log_file"
                fi
                ;;
            *gfycat*)
                youtube-dl "$file_url" >/dev/null
                if [ $(echo $?) = 0 ]; then
                    echo $(date) downloaded video $file_url >> "$log_file"
                    echo "$file_url" >> "$cache_file"
                    videos_downloaded=$(expr $videos_downloaded + 1)
                else
                    echo $(date) failed to download video $file_url >> "$log_file"
                fi
                ;;
        esac
    fi
done

notify-send "$images_downloaded images, $videos_downloaded videos were downloaded from reddit" -t 60000
echo "DONE" $(date) >> "$log_file"
