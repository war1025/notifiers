#!/bin/sh

amixer -D pulse sset Master 3%+ >> /dev/null

~/.local/share/notifiers/volume/show-volume.sh >> /dev/null


