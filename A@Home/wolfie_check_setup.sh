#!/bin/sh

if [ -n "$1" ]
then
    # make sure device is fully booted before starting
    echo 'Connecting to device'
    adb connect $1:4321
    adb wait-for-device shell "/data/local/dhrystone" &'
    echo 'Done with this device'
    adb disconnect

else
    echo 'What device am I setting up?'
fi

