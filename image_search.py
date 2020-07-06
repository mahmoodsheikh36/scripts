#!/usr/bin/python3
import requests
import sys
import json
from signal import signal, SIGPIPE, SIG_DFL
signal(SIGPIPE,SIG_DFL) 

searx_instance = 'https://searx.lukesmith.xyz/'

def do_image_search(search_term):
    data = {
        'q': search_term,
        'time_range': '',
        'language': 'en-US',
        'category_images': '1',
        'pageno': '1',
        'format': 'json'
    }
    return requests.post(searx_instance, data=data).json()

def print_image_urls(image_search_results):
    for result in image_search_results['results']:
        print(result['img_src'])

if __name__ == '__main__':
    print_image_urls(do_image_search(' '.join(sys.argv[1:])))
