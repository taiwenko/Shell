#!/bin/sh

if [ -n "$1" ]
then
    #make sure device is fully booted before starting
    echo 'Connecting to device'
    adb connect $1:4321
    adb wait-for-device
    adb root
    sleep 1
    adb connect $1:4321
    adb wait-for-device
    adb remount
    adb wait-for-device
    echo 'Pushing new AVR firmware file'
    adb push sledadk_controller.bin /vendor/firmware/sledadk_controller.bin
    echo 'Updating AVR firmware with file just pushed'
    adb shell avr_updater -f /vendor/firmware/sledadk_controller.bin
    echo 'Rebooting'
    adb reboot &
    sleep 2
    echo 'Done with this device'
    adb disconnect

else
    echo 'What device am I setting up?'
fi

