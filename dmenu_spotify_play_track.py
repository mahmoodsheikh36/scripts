#!/bin/python
import json
from os.path import expanduser
import os
import subprocess
import requests
from signal import signal, SIGPIPE, SIG_DFL
signal(SIGPIPE,SIG_DFL) 

access_file = expanduser('~') + '/Dropbox/mydata/spotify_data/access_values.json'
with open(access_file) as access_file_reader:
    access_token = json.loads(access_file_reader.read())['access_token']

lib_tracks_file = expanduser('~') + '/.cache/spotify_dmenu/lib_tracks.json'
with open(lib_tracks_file) as lib_tracks_file_reader:
    tracks = json.loads(lib_tracks_file_reader.read())
    tracks_str = []
    first_track = True
    with open("/tmp/dmenu_spotify", "w+") as tmp_file:
        for track in tracks:
            track_str = "{} - {}".format(track["name"], track['artists'][0]['name'])
            tracks_str.append(track_str)
            if first_track:
                first_track = False
                tmp_file.write(track_str)
            else:
                tmp_file.write("\n")
                tmp_file.write(track_str)

track_to_play_str = subprocess.check_output("cat /tmp/dmenu_spotify | dmenu -l 15 -i -sb '#208820' | tr -d '\n'", shell=True, universal_newlines=True)

track_to_play=None
for idx, track_str in enumerate(tracks_str):
    if track_str == track_to_play_str:
        track_to_play = tracks[idx]

if track_to_play:
    track_to_play_uri = track_to_play['uri']
    os.system('notify-send "sent request"')
    print('playing track uri {}'.format(track_to_play_uri))
    requests.put("https://api.spotify.com/v1/me/player/play", data={'context_uri': track_to_play_uri}, headers={'Authorization': 'Bearer ' + access_token})
    os.system('notify-send "track played"')
else:
    os.system("notify-send 'song not found'")
