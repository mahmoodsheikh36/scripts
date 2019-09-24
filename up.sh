#!/usr/bin/sh

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
else
    for (( i=1; i<=$1; i++ ))
    do
        pwd
        cd ..
    done
fi
