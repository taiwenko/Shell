#!/bin/sh

if [ -n "$1" ]
then
    # make sure device is fully booted before starting
    echo 'Connecting to device'
    adb connect $1:4321
    adb wait-for-device
    adb root
    sleep 1
    adb connect $1:4321
    adb wait-for-device
    adb remount
    adb wait-for-device
    echo 'Pushing files'
    adb push dhrystone /data/local
    sleep 2
    echo 'Setting execution bits'
    adb shell chmod 777 /data/local/dhrystone
    echo 'Rebooting'
    adb reboot &
    echo 'Done with this device'
    adb disconnect

else
    echo 'What device am I setting up?'
fi

