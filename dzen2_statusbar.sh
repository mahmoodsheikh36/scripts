#!/usr/bin/sh

emoji_font="Noto Color Emoji-13"
text_font="Source Code Pro-13"

volume_emoji="^fn($emoji_font)🔊^fn($text_font)"
time_emoji="^fn($emoji_font)🕒^fn($text_font)"
liked_song_emoji="^fn($emoji_font)💕^fn($text_font)"
music_emoji="^fn($emoji_font)🤘^fn($text_font)"

VOL() {
    amixer get Master | awk '/%/ {print $4}' | tr -d '[]'
}

LAYOUT() {
    setxkbmap -query | awk '/layout/ {print $2}'
}

MUSIC() {
    current_song=$(music_daemon_cmd.sh current)
    is_liked=$(music_daemon_cmd.sh is_liked $(echo $current_song | cut -d ' ' -f1))
    echo -n "$music_emoji "
    $is_liked && echo -n "$liked_song_emoji $current_song" ||\
        echo -n "$current_song"
    echo -n ' '
    music_daemon_cmd.sh progress
}

WORKSPACES() {
    workspaces=$(bspc query --desktops -d .local --names)
    current_workspace=$(bspc query --desktops -d focused --names)
    active_color="#ffffff"
    for workspace in $workspaces; do
        [ "$workspace" = "$current_workspace" ] &&\
            echo -n "^fg(#00ff00)[$workspace]^fg(#bbbbbb)" || echo -n "$workspace"
        echo -n ' '
    done
}

(while true; do
    date=$(date "+%H:%M:%S (%a) %d/%m/%y")
    echo "$(LAYOUT) | $(MUSIC) | $volume_emoji $(VOL) | $time_emoji $date"
    sleep 0.5;
done) | dzen2 -p -x 5 -y 5 -w 1910 -fn "$text_font" -title-name dzen2_statusbar_top &

(while true; do
    date=$(date "+%H:%M:%S (%a) %d/%m/%y")
    echo "$(WORKSPACES)"
    sleep 0.5;
done) | dzen2 -p -x 5 -y 5 -w 1910 -y 1050 -fn "$text_font" -title-name dzen2_statusbar_bottom &
