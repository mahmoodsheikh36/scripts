#!/bin/sh

db_file="$HOME/media/script_data/open.sh"

is_file() {
    [ -f "$1" ] && echo true
}

log() {
    echo "$@" >> "$db_file"
}
log_no_line_feed() {
    echo -n "$@" >> "$db_file"
}

file_path() {
    case "$1" in
        ./*)
            echo "$PWD$(echo $1 | cut -c2-)"
            ;;
        */*)
            echo "$1"
            ;;
        *)
            echo "$PWD/$1"
            ;;
    esac
}

get_mime() {
    file -L --mime-type "$1" | rev | cut -d ' ' -f1 | rev
}

get_date() {
    date "+%H:%M:%S %d/%m/%y"
}

for arg in "$@"; do
    if $(is_file "$arg"); then
        file=$(file_path "$arg")
        mime=$(get_mime "$file")
        log_no_line_feed "($mime) "
        case "$mime" in
            image/gif)
                log_no_line_feed "$file is a gif"
                log_no_line_feed " playing gif $(get_date)"
                trap "log SIGINT received gif closed $(get_date) && exit 1" 2
                mpv "$file" --keep-open
                trap "exit" 2
                log " gif closed $(get_date)"
                ;;
            image/*)
                log_no_line_feed "$file is an image"
                log_no_line_feed " opening image $(get_date)"
                trap "log SIGINT received image closed $(get_date) && exit 1" 2
                sxiv "$file"
                trap "exit" 2
                log " image closed $(get_date)"
                ;;
            video/*)
                log_no_line_feed "$file is a video"
                log_no_line_feed " opening video $(get_date)"
                trap "log SIGINT received video closed $(get_date) && exit 1" 2
                mpv "$file" --keep-open
                trap "exit" 2
                log " video closed $(get_date)"
                ;;
            audio/*)
                log_no_line_feed "$file is an audio"
                log_no_line_feed " opening audio $(get_date)"
                trap "log SIGINT received audio closed $(get_date) && exit 1" 2
                mpv "$file" --keep-open
                trap "exit" 2
                log " audio closed $(get_date)"
                ;;
            text/*)
                log_no_line_feed "$file is a text file"
                log_no_line_feed " opening file $(get_date)"
                trap "log SIGINT received file closed $(get_date) && exit 1" 2
                vim "$file"
                trap "exit" 2
                log " file closed $(get_date)"
                ;;
            application/pdf)
                log_no_line_feed "$file is a pdf document"
                log_no_line_feed " opening document $(get_date)"
                trap "log SIGINT received document closed $(get_date) && exit 1" 2
                zathura "$file"
                trap "exit" 2
                log " document closed $(get_date)"
                ;;
            *)
                log "couldnt open $file $(get_date)"
                ;;
        esac
    else
        log "$arg is not a file $(get_date)"
    fi
done
