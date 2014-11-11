#!/bin/bash

function muted {
	if [ $(amixer get Master | tail -n 1 | awk '{print $6}') = "[off]" ]; then
		echo "true"
	else
		echo "false"
	fi
}

VOLUME=$(amixer get Master | tail -n 1 | awk '{print $4}')

echo $VOLUME $(muted)

gdbus call --session --dest "org.wrowclif.Volume" --object-path "/org/wrowclif/Volume" --method "org.wrowclif.Volume.ShowVolume" $VOLUME $(muted)

