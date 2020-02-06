#!/bin/python3
import json
import os
import subprocess
import sqlite3
import datetime

spotify_library_path = '/home/mahmooz/media/music/my_spotify_library.json'
audio_files_directory = '/home/mahmooz/media/music/audio/'
database_path = '/home/mahmooz/media/music/data.sqlite'

def get_audio_files_and_spotify_ids():
    spotify_ids = []
    audio_files = []
    for audio_file in os.listdir(audio_files_directory):
        file_path = audio_files_directory + audio_file

        spotify_id_cmd_str = '''
            ffmpeg -i "{}" 2>&1 | grep -o 'https://open\.spotify\.com/track/[a-zA-Z0-9]\+$' | \
            rev | cut -d '/' -f1 | rev
        '''.format(file_path.replace('"', '\\"'))

        spotify_id_cmd = subprocess.Popen(spotify_id_cmd_str, 
                                        stdout=subprocess.PIPE, 
                                        stderr=subprocess.STDOUT,
                                        shell=True)
        spotify_id,_ = spotify_id_cmd.communicate()
        if len(spotify_id.strip()):
            spotify_ids.append(spotify_id.decode().strip())
            audio_files.append(file_path)
            print(spotify_id.decode().strip(), file_path)

    return audio_files, spotify_ids

def update_date_of_entry(db_connection, file_path, date):
    update_cmd='UPDATE songs SET date_of_entry = ? WHERE audio_file_path = ?'
    db_connection.execute(update_cmd, (date, file_path))

if __name__ == '__main__':
    with open(spotify_library_path) as spotify_library_file:
        library = json.loads(spotify_library_file.read())

    db_connection = sqlite3.connect(database_path)

    audio_files, spotify_ids = get_audio_files_and_spotify_ids()
    for i in range(len((audio_files))):
        audio_file = audio_files[i]
        spotify_id = spotify_ids[i]
        for page in library:
            for item in page['items']:
                if item['track']['id'] == spotify_id:
                    date = datetime.datetime.fromisoformat(item['added_at'].replace('Z', '').replace('T', ' '))
                    update_date_of_entry(db_connection, audio_file, date)

    db_connection.commit()
    db_connection.close()
