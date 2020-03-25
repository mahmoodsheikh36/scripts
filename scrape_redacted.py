#!/usr/bin/python
import requests
import numpy
import random

headers = {
    'user-agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:74.0) Gecko/20100101 Firefox/74.0'
}
cookies = {
    'session': 'y2s90lha4chNxbQrIoKXpECbYWRf5jM%2B9F0Rcow%2F7LDBgfXAccYq2GNllb%2B%2FQYqqggClTL9Eh7u9XFOezHJzCJxX27jNg3WFVBBZ5dRpHZw2p1yagOiQPfFekp1LwE4Z%3AchMbCDoJk8UkAk90VQUyUA%3D%3D'
}

id_limit = 1500000
ids = [random.randint(1, id_limit) for i in range(id_limit)]
ids_idx = 0

def get_next_id():
    global ids_idx
    next_id = ids[ids_idx]
    ids_idx += 1
    return next_id

def get_url_for_id(my_id):
    return 'https://redacted.ch/torrents.php?action=download&id={}&authkey=7e74878a537345b82916899a6d6bc6cd&torrent_pass=65f69237a511eaf189f1a29398b3bbb4'.format(my_id)

while True:
    current_id = get_next_id()
    r = requests.get(get_url_for_id(current_id), cookies=cookies, headers=headers)
    with open('{}.torrent'.format(current_id), 'wb+') as torrent_file:
        torrent_file.write(r.content)
    print('got torrent {}'.format(current_id))
