#!/bin/sh

amixer -D pulse set Master toggle >> /dev/null

~/.local/share/notifiers/volume/show-volume.sh >> /dev/null
