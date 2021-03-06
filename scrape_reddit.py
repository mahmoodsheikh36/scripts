#!/usr/bin/python3
import requests
import json
import random
import sqlite3
import time
import sys
import subprocess
from pathlib import Path

current_time = lambda: int(round(time.time() * 1000))

if len(sys.argv) == 1:
    print('enter top/hot as first arg to get top posts or hot posts')
    sys.exit(1)
if len(sys.argv) == 2:
    print('enter subreddit name as second argument')
    sys.exit(1)

subreddit = sys.argv[2]
post_type = sys.argv[1] # should be "top" or "hot"
save_dir = str(Path.home()) + '/{}/'.format(subreddit)

if len(sys.argv) > 3:
    save_dir = sys.argv[3] + '/{}/'.format(subreddit)
Path(save_dir).mkdir(exist_ok=True, parents=True)

IMAGE_EXTENSIONS = ['jpg', 'jpeg', 'png', 'webp']

def dict_factory(cursor, row):
    d = {}
    for idx, col in enumerate(cursor.description):
        d[col[0]] = row[idx]
    return d

db_conn = sqlite3.connect(save_dir + 'data.sqlite')
db_conn.row_factory = dict_factory

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

REDDIT_LISTING_LIMIT = 3000 # its actually 1000 but i wanna be safe
REDDIT_MAX_REQUEST_LIMIT = 100
HOT_POSTS_LIMIT = REDDIT_MAX_REQUEST_LIMIT

def get_user_agent():
    return random.choice(USER_AGENTS)

def get_top_posts_data(after, cnt):
    if not cnt * REDDIT_MAX_REQUEST_LIMIT < REDDIT_LISTING_LIMIT:
        return None
    if after is None:
        url = 'https://reddit.com/r/{}/top.json?t=all&limit={}'.format(subreddit, REDDIT_MAX_REQUEST_LIMIT)
    else:
        url = 'https://reddit.com/r/{}/top.json?t=all&limit={}&after={}'.format(subreddit, REDDIT_MAX_REQUEST_LIMIT, after)
    return get_data(url)

def get_hot_posts_data():
    url = 'https://reddit.com/r/{}/hot.json?limit={}'.format(subreddit,
                                                             HOT_POSTS_LIMIT)
    return get_data(url)
    
def get_data(url):
    response = requests.get(url, headers={'user-agent': get_user_agent()})
    parsed_response = json.loads(response.text)
    if not 'data' in parsed_response:
        return None
    return json.loads(response.text)['data']

def download_file(url, local_path):
    is_image = False
    for image_extension in IMAGE_EXTENSIONS:
        if url.endswith('.' + image_extension):
            is_image = True
    if is_image:
        try:
            response = requests.get(url, allow_redirects=True, timeout=10,
                                    headers={'user-agent': get_user_agent()})
            with open(local_path, 'wb+') as output_file:
                output_file.write(response.content)
            return True
        except requests.exceptions.RequestException:
            return False
    else:
        out = subprocess.run(['youtube-dl', url, '-o', local_path], stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL)
        exit_code = out.returncode
        return exit_code == 0

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
    return last_post[3]

def get_post_from_db(post_name):
    return db_conn.execute('SELECT * FROM images WHERE post_name = ?',
                           (post_name,)).fetchone()

def update_upvotes(post_name, upvotes):
    db_conn.execute('UPDATE images SET upvotes = ? WHERE post_name = ?',
                    (upvotes, post_name))
    db_conn.commit()

def handle_post(post_data):
    db_post = get_post_from_db(post_data['name'])
    if db_post is not None:
        old_upvotes = db_post['upvotes']
        new_upvotes = post_data['ups']
        if old_upvotes != new_upvotes:
            print('updating upvotes from {} to {} for {}'.format(old_upvotes,
                    new_upvotes, post_data['title']))
            update_upvotes(post_data['name'], new_upvotes)
        else:
            print('already handled {}'.format(post_data['title']))
        return
    is_image = False
    for image_extension in IMAGE_EXTENSIONS:
        if post_data['url'].endswith('.{}'.format(image_extension)):
            is_image = True
            print("downloading image of {}".format(post_data['title']))
    if not is_image:
        print('downloading something (maybe video/gif) of {}'.format(post_data['title']))
    filename = post_data['name'] + '_{}_{}'.format(post_data['ups'], post_data['title'])
    filename = filename.replace('/', '_')
    if len(filename) > 250:
        filename = filename[:250]
    try:
        if not download_file(post_data['url'], save_dir + filename):
            print('failed to download {}'.format(post_data['title']))
        else:
            add_to_db(filename, post_data)
    except requests.exceptions.RequestException as e:
        print('couldnt download {}'.format(post_data['title']))

if __name__ == '__main__':
    try:
        if post_type == 'hot':
            data = get_hot_posts_data()
            if data:
                for post in data['children']:
                    handle_post(post['data'])
                after = data['after']
        elif post_type == 'top':
            cnt = 1
            after = None
            data = get_top_posts_data(after, cnt)
            while data is not None:
                for post in data['children']:
                    handle_post(post['data'])
                    after = post['data']['name']
                cnt += 1
                data = get_top_posts_data(after, cnt)
    except KeyboardInterrupt:
        db_conn.close()
