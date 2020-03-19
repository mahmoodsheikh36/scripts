#!/bin/python
import urllib.parse
import sys

print(urllib.parse.quote(sys.stdin.read()))
