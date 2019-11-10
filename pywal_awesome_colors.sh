#!/bin/sh
echo test > ~/test

fg=`cat ~/.cache/wal/colors | tail -1 | tr -d '\n'`
bg=`cat ~/.cache/wal/colors | head -1 | tr -d '\n'`

echo -n "
beautiful = require('beautiful')
awful = require('awful')
beautiful.taglist_fg_focus = '$bg'
beautiful.taglist_bg_focus = '$fg'
beautiful.bg_normal = '$bg'
beautiful.fg_normal = '$fg'
beautiful.status_text_color = '$fg'
-- beautiful.wibar_bg = '$bg'
-- beautiful.wibar_fg = '$fg'
-- screen.primary.mywibox.fg = '$fg'
screen.primary.mywibox.bg = '$bg'
" | awesome-client
echo hi >> ~/test
