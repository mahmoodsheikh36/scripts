#!/usr/bin/sh
# dwm_statusbar.sh - statusbar script

VOL() {
    amixer get Master | awk '/%/ {print $4}' | tr -d '[]'
}

BATTERY() {
    cat /sys/class/power_supply/BAT0/capacity | tr -d '\n'
    echo -n '%'
}

LAYOUT() {
    setxkbmap -query | awk '/layout/ {print $2}'
}

STORAGE() {
    df -h | awk '/\/$/ {print $3 " / " $2}'
}

MEM() {
    free -h | awk '/Mem/ {print $3 " / " $2}'
}

MUSIC() {
    current_song=$(music_daemon_cmd.sh current)
    [ "$current_song" = "" ] && echo NO MUSIC && return
    is_liked=$(music_daemon_cmd.sh is_liked $(echo $current_song | cut -d ' ' -f1))
    #echo -n '🤘'
    $is_liked && echo -n "[LIKED] $current_song" || echo -n "$current_song"
    echo -n " "
    music_daemon_cmd.sh progress
    echo -n " [$(music_daemon_cmd.sh mode)]"
}

#MUSIC() {
#    song=$(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | grep 'title' -A1 | tail -1 | tr -s ' ' | cut -d ' ' -f4- | sed 's/^"//; s/"$//')
#    artist=$(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | grep ':artist' -A2 | tail -1 | tr -s ' ' | cut -d ' ' -f3- | sed 's/^"//; s/"$//')
#    echo $song - $artist
#}

date=$(date "+%H:%M:%S (%a) %d/%m/%y")
#echo "⌨ $(LAYOUT)|$(MUSIC)|🔊 $(VOL)|🕒 $date"
echo "$(LAYOUT)|$(MUSIC)|VOL $(VOL)|TIME $date"
