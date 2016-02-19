#!/bin/bash
COUNTER=0

adb disconnect
if [ -n "$2" ]
then
    echo "Check permissions started..."
    for COUNTER in `seq $1 $2`; do
        adb connect alt$COUNTER:4321
        adb wait-for-device shell ls -la /system/bin/sush
        adb wait-for-device shell getprop ro.build.id
        adb wait-for-device shell getprop ro.serialno
        adb disconnect
    done
else
    echo 'What device am I querying'
fi

