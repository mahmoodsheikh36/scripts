#!/bin/sh

program=`ls /usr/bin | dmenu.sh -i -p "program"`
$program
