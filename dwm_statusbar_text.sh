#!/bin/sh

time=`date "+%H:%M"`
volume=`amixer get Speaker -c 1 | tail -1 | cut -d "[" -f2 | cut -d "%" -f1`
text="  VOL  $volume%   |   TIME  $time"
echo "$text"
