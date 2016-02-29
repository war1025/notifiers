#!/bin/bash

gdbus call --system --dest=org.freedesktop.UPower --object-path=/org/freedesktop/UPower/devices/battery_BAT0 --method=org.freedesktop.UPower.Device.Refresh

STATE=$(gdbus call --system --dest=org.freedesktop.UPower --object-path=/org/freedesktop/UPower/devices/battery_BAT0 --method=org.freedesktop.DBus.Properties.Get org.freedesktop.UPower.Device State | sed -e "s/(<uint32 //g" -e "s/>,)//g")

if [ $STATE = "1" ]; then
	TIME=$(gdbus call --system --dest=org.freedesktop.UPower --object-path=/org/freedesktop/UPower/devices/battery_BAT0 --method=org.freedesktop.DBus.Properties.Get org.freedesktop.UPower.Device TimeToFull | sed -e "s/(<int64 //g" -e "s/>,)//g")
else
	TIME=$(gdbus call --system --dest=org.freedesktop.UPower --object-path=/org/freedesktop/UPower/devices/battery_BAT0 --method=org.freedesktop.DBus.Properties.Get org.freedesktop.UPower.Device TimeToEmpty | sed -e "s/(<int64 //g" -e "s/>,)//g")
fi

PERCENTAGE=$(gdbus call --system --dest=org.freedesktop.UPower --object-path=/org/freedesktop/UPower/devices/battery_BAT0 --method=org.freedesktop.DBus.Properties.Get org.freedesktop.UPower.Device Percentage | sed -e "s/(<//g" -e "s/>,)//g")


gdbus call --session --dest "org.wrowclif.Battery" --object-path "/org/wrowclif/Battery" --method "org.wrowclif.Battery.ShowBattery" $PERCENTAGE $STATE $TIME

