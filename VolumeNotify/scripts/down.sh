#!/bin/sh

SINK=$(pactl list short sinks | grep alsa | awk '{print $1}')

pactl set-sink-volume $SINK -3% >> /dev/null

~/.local/share/notifiers/volume/show-volume.sh >> /dev/null
