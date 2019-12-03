#!/bin/sh
# diary.sh - writing my diaries in vim

date=`date "+%H:%M:%S %d/%m/%y"`
notify-send "writing diaries for $date" -t 10000

vim /tmp/diary

if [ -f /tmp/diary ]; then
    if [ ! "`cat /tmp/diary`" = "" ]; then
        diary_file="$HOME/media/diary/`echo $date | tr "/" "_"`"
        echo "$date" > "$diary_file"
        cat /tmp/diary >> "$diary_file"
        echo `date "+%H:%M:%S %d/%m/%y" | tr "/" "_"` >> "$diary_file"
        notify-send "saved diary for $date" -t 10000
    fi
    rm /tmp/diary
fi
