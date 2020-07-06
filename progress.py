#!/usr/bin/python3
import sys
import argparse
import math
from decimal import Decimal, getcontext
getcontext().prec = 3

parser = argparse.ArgumentParser(description='display progress bar in text')
parser.add_argument('-l', '--length', metavar='length', type=int,
                    help='length of the statusbar', required=True)
parser.add_argument('-p', '--percentage', metavar='percentage', type=int,
                    help='the percentage of the statusbar to fill',
                    required=True)
args = parser.parse_args()

length = Decimal(args.length)
percentage = Decimal(args.percentage)

ticks = length * (1 - percentage / 100)
hashes = length * (percentage / 100)

print('[{}{}]'.format(math.floor(hashes)*'#', math.ceil(ticks)*'-'), end='')
