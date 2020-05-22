#!/bin/python3
# get lyrics from genius.com
import requests
from bs4 import BeautifulSoup
import sys

user_agent = 'Mozilla/5.0 (Linux; U; Android 2.2) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1'

def get_lyrics(song_name, artist_name):
    CHARS_TO_REMOVE = ".'?!"
    for char_to_remove in CHARS_TO_REMOVE:
        artist_name = artist_name.replace(char_to_remove, "").replace('/', '-')
        song_name = song_name.replace(char_to_remove, "")
    url = "https://genius.com/{}-{}-lyrics".format(
            artist_name.replace('& ', 'and ').replace(' ', '-').capitalize(),
            song_name.replace('& ', 'and ').replace(' ', '-'))
    bs = BeautifulSoup(requests.get(url, headers={'user-agent': user_agent}
        ).content.decode(), 'html.parser')
    lyrics = bs.find_all("div", {"class": "lyrics"})[0].find_all('p')[0].text
    return lyrics

if __name__ == '__main__':
    try:
        artist_name = sys.argv[2]
        song_name   = sys.argv[1]
        print(get_lyrics(song_name, artist_name))
    except:
        pass
