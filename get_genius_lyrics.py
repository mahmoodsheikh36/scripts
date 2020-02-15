#!/bin/python3
# get lyrics from genius.com
import requests
from bs4 import BeautifulSoup

artist_name = 'radiohead'
song_name   = 'everything in its right place'
 
def get_lyrics_tag(artist_name, song_name):
    url = "https://genius.com/{}-{}-lyrics".format(
            '-'.join(artist_name.capitalize().split(' ')),
            '-'.join(song_name.split(' ')))
    soup = BeautifulSoup(requests.get(url).content.decode(), 'html.parser')
    return soup.find_all("div", {"class": "lyrics"})[0]

print(get_lyrics_tag(artist_name, song_name).find_all('p')[0].text)
