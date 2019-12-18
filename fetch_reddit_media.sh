#!/bin/sh
# fetch_reddit_media.sh - download images and videos from reddit

IFS='
'

get_date() {
    date "+%H:%M:%S %d/%m/%y"
}

should_fetch_top_posts=true

subreddits_file="$HOME/workspace/scripts/subreddits.txt"
download_dir=$HOME/media/reddit
log_file="$HOME/media/script_data/fetch_reddit_media_logs/log_$(get_date | tr "/" "_")"
cache_file="$HOME/media/script_data/fetch_reddit_media.sh"
if [ ! -z "$1" ]; then
    subreddits_file="$1"
fi
if [ ! -z "$2" ]; then
    download_dir=$2
fi
if [ ! -z "$3" ]; then
    log_file="$3"
fi
if [ ! -z "$4" ]; then
    cache_file="$4"
fi

ln -sf $log_file $HOME/.cache/fetch_reddit_media_log

if [ ! -f $cache_file ]; then
    touch $cache_file
fi
if [ ! -d $download_dir ]; then
    mkdir -p $download_dir
fi
cd "$download_dir"
echo $(get_date) logging to "$log_file"
echo START $(get_date) >> "$log_file"

get_subreddits() {
    grep "^/r/" "$subreddits_file" | sort -u 
}

fetch_urls() {
    subreddit_url="$1"
    curl "$subreddit_url" -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:71.0) Gecko/20100101 Firefox/71.0" 2>/dev/null | grep -o "https://\(i\.\|\)\(gfycat\|redd\|imgur\)\.\(it\|com\)/[a-zA-Z0-9]*\(\.\(gif\|jpg\|png\)\|\)"
}

images_downloaded=0
videos_downloaded=0
for subreddit in $(get_subreddits); do
    echo $(get_date) "downloading from $subreddit" >> "$log_file"
    subreddit_name=$(echo $subreddit | cut -d '/' -f3)
    subreddit_dir=$download_dir/$subreddit_name/
    cd $subreddit_dir
    subreddit_url=$(echo $subreddit | awk '{print "https://www.reddit.com" $0 ".rss?limit=100"}')
    file_urls=$(fetch_urls $subreddit_url)
    if $should_fetch_top_posts; then
        file_urls="$file_urls $(fetch_urls $(echo $subreddit | awk '{print "https://www.reddit.com" $0 "/top.rss?t=all&limit=100"}'))"
    fi
    for file_url in $file_urls; do
        if [ -z "$(grep "$file_url" "$cache_file")" ]; then
            case "$file_url" in
                *.jpg|*.png|*.gif)
                    if [ ! -d $subreddit_dir ]; then
                        mkdir -p $subreddit_dir
                    fi
                    curl -O "$file_url" 2>/dev/null
                    if [ $(echo $?) = 0 ]; then
                        echo $(get_date) downloaded image $file_url >> "$log_file"
                        echo "$file_url" >> "$cache_file"
                        images_downloaded=$(expr $images_downloaded + 1)
                    else
                        echo $(get_date) failed to download image $file_url >> "$log_file"
                    fi
                    ;;
                *gfycat*)
                    if [ ! -d $subreddit_dir ]; then
                        mkdir -p $subreddit_dir
                    fi
                    youtube-dl "$file_url" >/dev/null
                    if [ $(echo $?) = 0 ]; then
                        echo $(get_date) downloaded video $file_url >> "$log_file"
                        echo "$file_url" >> "$cache_file"
                        videos_downloaded=$(expr $videos_downloaded + 1)
                    else
                        echo $(get_date) failed to download video $file_url >> "$log_file"
                    fi
                    ;;
            esac
        fi
    done
    cd $download_dir
done

notify-send "$images_downloaded images, $videos_downloaded videos were downloaded from reddit" -t 60000
echo "DONE" $(get_date) >> "$log_file"
exit
