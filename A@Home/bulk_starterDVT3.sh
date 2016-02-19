#!/bin/sh
COUNTER=0

if [ -n "$2" ]
then
    COUNTER=$(($1-1))
	while [  $COUNTER -lt $2 ]; do
        COUNTER=$(( $COUNTER + 1))
        echo 'Setting up 192.168.0.'$COUNTER
        adb connect 192.168.0.$COUNTER:4321
        adb wait-for-device
        adb shell sush /system/accelerated.sh
        adb disconnect
        sleep 1
    done
else
    echo 'Please enter starting and ending IP addresses'
fi
