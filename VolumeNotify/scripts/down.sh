#!/bin/sh

#amixer set Master 3%- >> /dev/null

pactl -- set-sink-volume 0 -3%

/home/war1025/Volume/show-volume.sh >> /dev/null
