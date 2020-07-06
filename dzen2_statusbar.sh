#!/usr/bin/sh

emoji_font="Noto Color Emoji-13"
text_font="Hack-14"

volume_emoji="^fn($emoji_font)🔊^fn($text_font)"
time_emoji="^fn($emoji_font)🕒^fn($text_font)"
liked_song_emoji="^fn($emoji_font)💕^fn($text_font)"
music_emoji="^fn($emoji_font)🤘^fn($text_font)"

VOL() {
    pactl list sinks | awk '/^\sVolume:/ {print $5}'
}

LAYOUT() {
    setxkbmap -query | awk '/layout/ {print $2}'
}

MUSIC() {
    song=$(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | grep 'title' -A1 | tail -1 | tr -s ' ' | cut -d ' ' -f4- | sed 's/^"//; s/"$//')
    artist=$(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | grep ':artist' -A2 | tail -1 | tr -s ' ' | cut -d ' ' -f3- | sed 's/^"//; s/"$//')
    echo $song - $artist
}

WORKSPACES() {
    workspaces=$(bspc query --desktops -d .local --names)
    current_workspace=$(bspc query --desktops -d focused --names)
    for workspace in $workspaces; do
        [ "$workspace" = "$current_workspace" ] &&\
            echo -n "^fg(#00ff00)[$workspace]^fg(#ffffff)" || echo -n "$workspace"
        echo -n ' '
    done
}

(while true; do
    date=$(date "+%H:%M:%S (%a) %d/%m/%y")
    echo "$(LAYOUT) | $music_emoji $(MUSIC) | $volume_emoji $(VOL) | $time_emoji $date"
    sleep 0.5;
done) | dzen2 -p -x 5 -y 5 -w 1910 -fn "$text_font" -title-name dzen2_statusbar_top &

(while true; do
    date=$(date "+%H:%M:%S (%a) %d/%m/%y")
    echo "$(WORKSPACES)"
    sleep 0.35;
done) | dzen2 -p -x 5 -y 5 -w 1910 -y 1050 -fn "$text_font" -title-name dzen2_statusbar_bottom

wait
