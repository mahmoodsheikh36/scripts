#!/usr/bin/python3
import json
import pathlib
import os
import subprocess
import threading
import sys
import psutil
from concurrent.futures import ThreadPoolExecutor 
from signal import signal, SIGPIPE, SIG_DFL
signal(SIGPIPE,SIG_DFL)

music_dir = str(pathlib.Path.home()) + '/music/'
metadata_cmd = 'ffprobe -loglevel panic -show_entries format_tags'

AUDIO_FILE_EXTENSIONS = ['mp3', 'flac']

tags_to_print = sys.argv[1:]
if not tags_to_print:
    tags_to_print = ['title', 'artist', 'album']

def get_tags(filepath):
    tags_map = json.loads(subprocess.check_output(
        ['ffprobe',
         '-loglevel',
         'panic',
         '-show_entries',
         'format_tags',
         '-of',
         'json',
         filepath]))['format']['tags']
    tags_map_lowercase = {k.lower():v for k,v in tags_map.items()}
    return tags_map_lowercase

def handle_filepath(filepath):
    tags = get_tags(filepath)
    try:
        txt = ''
        for i in range(len(tags_to_print)):
            if i == len(tags_to_print) - 1:
                txt += tags[tags_to_print[i]]
            else:
                txt += tags[tags_to_print[i]] + ' - '
        print(txt, flush=True)
    except Exception:
        print('no title tag', flush=True)

with ThreadPoolExecutor(max_workers=psutil.cpu_count()) as executor:
    for folder, subs, files in os.walk(music_dir):
        for filename in files:
            is_audio_file = False
            for audio_ext in AUDIO_FILE_EXTENSIONS:
                if filename.endswith('.' + audio_ext):
                    is_audio_file = True
            if not is_audio_file:
                continue
            filepath = os.path.join(folder, filename)
            executor.submit(handle_filepath, filepath)
