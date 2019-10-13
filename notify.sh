#!/bin/sh
# notify.sh

msg=$@
echo "require('naughty').notify({text='$msg'})" | awesome-client
echo "$msg"
