#!/bin/sh
# usrhandler.sh - basically xdg-open but for urls

url_from_last_slash=`echo $1 | rev | cut -d "/" -f1 | rev`
extension=`echo $url_from_last_slash | rev | cut -d "." -f1 | rev`

case $extension in
    jpg|png|jpeg)
        curl -o /tmp/image "$1"
        sxiv /tmp/image
        ;;
    *)
        qutebrowser "$1"
        ;;
esac
