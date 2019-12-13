#!/bin/sh
# fetch_reddit_images.sh - download images from reddit

subreddits="https://www.reddit.com/r/sexygirls.rss"
subreddits="${subreddits} https://www.reddit.com/r/PrettyGirls.rss"
subreddits="${subreddits} https://www.reddit.com/r/goddesses.rss"
subreddits="${subreddits} https://www.reddit.com/r/hardbodies.rss"
subreddits="${subreddits} https://www.reddit.com/r/gentlemanboners.rss"
subreddits="${subreddits} https://www.reddit.com/r/FitAndNatural.rss"

cache_file="$HOME/media/script_data/fetch_reddit_images.sh"
download_dir="$HOME/media/images/reddit"

if [ ! -f "$cache_file" ]; then
    touch "$cache_file"
fi
if [ ! -d "$download_dir" ]; then
    mkdir "$download_dir"
fi

cd "$download_dir"

fetch_images() {
    echo "$subreddits" | tr ' ' '\n' | while read subreddit_url; do
        curl "$subreddit_url" -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:71.0) Gecko/20100101 Firefox/71.0" 2>/dev/null | grep -o "https://i\.\(redd\|imgur\)\.\(it\|com\)/[a-zA-Z0-9]*\.\(jpg\|png\)"
    done
}

images_downloaded=0
fetch_images | while read image_url; do
    if [ -z "$(grep "$image_url" "$cache_file")" ]; then
        curl -O "$image_url" 2>/dev/null
        echo downloaded $image_url
        echo "$image_url" >> "$cache_file"
        images_downloaded=$(expr $images_downloaded + 1)
    fi
done

echo "$images_downloaded images were downloaded"
notify-send "$images_downloaded images were downloaded" -t 60000
