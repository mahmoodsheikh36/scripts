#!/bin/python
import requests
import os
import time
import json
import dbus
import traceback

def send_notification(msg):
    os.system('notify-send -t 10000 "Music Monitor" "{}"'.format(msg))

def fetch_music_data():
    r = requests.get("https://mahmoodsheikh.com/music/json")
    if r.status_code != 200:
        return None
    return json.loads(r.text)

def remove_duplicates(tracks):
    for i in range(len(tracks)):
        for j in range(i + 1, len(tracks)):
            if j >= len(tracks) or i >= len(tracks):
                continue
            if tracks[i]["name"] == tracks[j]["name"] and \
                    tracks[i]["artist"] == tracks[j]["artist"]:
                        tracks.remove(tracks[j])

if __name__ == '__main__':
    session_bus = dbus.SessionBus()
    bus_data = ("org.mpris.MediaPlayer2.spotify", "/org/mpris/MediaPlayer2")

    prev_song = None
    prev_artist = None
    prev_index = None
    while True:
        try:
            spotify_bus = session_bus.get_object(*bus_data)
            dbus_interface = dbus.Interface(spotify_bus, "org.freedesktop.DBus.Properties")
            metadata = dbus_interface.Get("org.mpris.MediaPlayer2.Player", "Metadata")
            artist_data = metadata.get("xesam:albumArtist")
            artist = next(iter(artist_data))
            song = metadata.get("xesam:title")
            album = metadata.get("xesam:album")

            mydata = fetch_music_data()
            if mydata != None:
                remove_duplicates(mydata)
                for index in range(len(mydata)):
                    track = mydata[index]
                    if track["artist"] == artist and track["name"] == song and track["album"] == album:
                        if prev_song == song and prev_artist == artist:
                            if prev_index > index:
                                print("new index", index)
                                if index < 50:
                                    send_notification("{} - {} was {}th and is now {}th".format(song, artist, prev_index, index))
                        else:
                            print("\"{} - {}\" with index {}".format(song, artist, index))
                        prev_artist = artist
                        prev_index = index
                        prev_song = song
            else:
                print('data is nulled')
            time.sleep(10)
        except Exception as e:
            traceback.print_exc()
            time.sleep(20)
    # for track in data:
