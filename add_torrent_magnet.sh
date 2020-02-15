SEEDBOX_IP="10.0.0.7"

transmission-remote "$SEEDBOX_IP" -a "$1" && notify-send 'added torrent'
