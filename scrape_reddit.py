#!/usr/bin/python3
import requests
import json
import random
import sqlite3
import time

current_time = lambda: int(round(time.time() * 1000))

SUBREDDIT = 'prettygirls'
ALLOWED_FILE_EXTENSIONS = ['jpg', 'png', 'jpeg']

from pathlib import Path
save_dir = str(Path.home()) + '/{}/'.format(SUBREDDIT)
Path(save_dir).mkdir(exist_ok=True)

db_conn = sqlite3.connect(save_dir + 'data.sqlite')

db_conn.executescript('''
    CREATE TABLE IF NOT EXISTS images (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        upvotes INTEGER NOT NULL,
        post_name TEXT NOT NULL UNIQUE,
        created INTEGER NOT NULL,
        author INTEGER NOT NULL,
        permalink TEXT NOT NULL,
        url TEXT NOT NULL,
        num_comments INTEGER NOT NULL,
        time_added INTEGER NOT NULL,
        filename TEXT NOT NULL
    );
''')

USER_AGENTS = [
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.77 Safari/537.36',
    'Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML like Gecko) Chrome/44.0.2403.155 Safari/537.36',
    'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2227.1 Safari/537.36',
    'Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2226.0 Safari/537.36',
]


def get_user_agent():
    return random.choice(USER_AGENTS)

def get_next_url(after):
    if after is None:
        return 'https://reddit.com/r/{}/top.json?t=all&limit=100'.format(SUBREDDIT)
    return 'https://reddit.com/r/{}/top.json?t=all&limit=100&after={}'.format(SUBREDDIT, after)

def get_data(after):
    response = requests.get(get_next_url(after),
                            headers={'user-agent': get_user_agent()})
    return json.loads(response.text)['data']

def download_file(url, local_path):
    response = requests.get(url, allow_redirects=True, timeout=10,
                            headers={'user-agent': get_user_agent()})
    with open(local_path, 'wb+') as output_file:
        output_file.write(response.content)

def add_to_db(filename, reddit_post_data):
    d = reddit_post_data
    db_conn.execute('''
    INSERT INTO images\
    (title, upvotes, post_name, created, author, permalink, url, num_comments,\
     filename, time_added)\
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ''',
    (d['title'], d['ups'], d['name'], d['created'], d['author'], d['permalink'],
     d['url'], d['num_comments'], filename, current_time()))
    db_conn.commit()

def get_last_post_name():
    last_post = db_conn.execute('SELECT * FROM images ORDER BY time_added\
                                 DESC LIMIT 1').fetchone()
    if last_post is None:
        return None
    print(last_post)
    return last_post[3]

if __name__ == '__main__':
    after = get_last_post_name()
    if after is None:
        print('running for the first time, here we go!')
    else:
        print('picking up where i left off: {}'.format(after))
    try:
        while True:
            data = get_data(after)
            for post in data['children']:
                post_data = post['data']
                download_this_post = False
                for allowed_extension in ALLOWED_FILE_EXTENSIONS:
                    if post_data['url'].endswith('.{}'.format(allowed_extension)):
                        download_this_post = True
                if not download_this_post:
                    print('skipping image for {}'.format(post_data['title']))
                    continue
                print('downloading image of {}'.format(post_data['title']))
                filename = post_data['name']
                try:
                    download_file(post_data['url'], save_dir + filename)
                    add_to_db(filename, post_data)
                except requests.exceptions.Timeout as e:
                    print('timeout, skipping {}'.format(post_data['title']))
            after = data['after']
    except KeyboardInterrupt:
        print('quit')
        db_conn.close()
