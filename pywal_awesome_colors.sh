#!/bin/sh
avg_color=`cat ~/.cache/wal/colors | head -3 | tail -1 | tr -d '\n'`
darkest_color=`cat ~/.cache/wal/colors | head -1 | tr -d '\n'`
brightest_color=`cat ~/.cache/wal/colors | tail -1`

echo -n "
awful = require('awful')
beautiful = require('beautiful')
awful = require('awful')
beautiful.taglist_fg_focus = '$brightest_color'
beautiful.taglist_bg_focus = '$avg_color'
-- beautiful.bg_normal = '$avg_color'
-- beautiful.fg_normal = '$avg_color'
beautiful.status_text_color = '$brightest_color'
-- beautiful.wibar_bg = '$darkest_color'
-- beautiful.wibar_fg = '$avg_color'
-- screen.primary.mywibox.fg = '$avg_color'
for s in screen do
    s.mywibox.bg = '$darkest_color'
end
beautiful.bg_systray = '$darkest_color'
focused_tag = awful.screen.focused().selected_tag
awful.tag.viewnext(focused_tag.screen)
awful.tag.viewprev(focused_tag.screen)
" | awesome-client
