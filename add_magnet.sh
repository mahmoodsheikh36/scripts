#!/usr/bin/sh

transmission-remote -a "$1" && notify-send "added torrent" || notify-send "couldnt add magnet"
