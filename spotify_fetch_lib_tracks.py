#!/bin/python
import requests
import json
from os.path import expanduser
import sys
from math import ceil
from signal import signal, SIGPIPE, SIG_DFL
signal(SIGPIPE,SIG_DFL) 

limit=50
access_file = expanduser('~') + '/Dropbox/mydata/spotify_data/access_values.json'
cache_file = expanduser('~') + '/.cache/spotify_dmenu/lib_tracks.json'
with open(access_file) as access_file_reader:
    access_token = json.loads(access_file_reader.read())['access_token']

all_tracks=[]

initial_data = json.loads(requests.get('https://api.spotify.com/v1/me/tracks?offset=0&limit={}'.format(limit), headers={'Authorization': 'Bearer ' + access_token}).content)

for data in initial_data["items"]:
    track = data["track"]
    all_tracks.append(track)

total_songs = initial_data['total']
offset=limit
for i in range(1, ceil(total_songs / limit)):
    new_data = json.loads(requests.get('https://api.spotify.com/v1/me/tracks?offset={}&limit={}'.format(offset, limit), headers={'Authorization': 'Bearer ' + access_token}).content)
    for data in new_data["items"]:
        track = data['track']
        all_tracks.append(track)
    offset += limit

with open(cache_file, 'w+') as cache_file_writer:
    cache_file_writer.write(json.dumps(all_tracks))
