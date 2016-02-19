#!/bin/sh

if [ -n "$1" ]
then
    #make sure device is fully booted before starting
    echo 'Connecting to device'
    adb connect $1:4321
    adb wait-for-device root
    adb connect $1:4321
    echo $1 >> serial_MAC.log
    adb shell "getprop ro.serialno" >> serial_MAC.log
    adb shell netcfg | grep -o 00:1a:..:..:..:.. >> serial_MAC.log
    adb disconnect

else
    echo 'What device am I setting up?'
fi

