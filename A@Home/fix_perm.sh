#!/bin/bash
COUNTER=0

adb disconnect
if [ -n "$2" ]
then
    echo "Fix permissions started..."
    for COUNTER in `seq $1 $2`; do
        adb connect alt$COUNTER:4321
        adb wait-for-device root
        sleep 1
        adb connect alt$COUNTER:4321
        adb wait-for-device remount
        sleep 1
        adb wait-for-device shell chown root.root /system/bin/sush
        adb wait-for-device shell chown root.root /system/accelerated.sh
        adb wait-for-device shell chmod 4755 /system/bin/sush
        adb wait-for-device shell chmod 755 /system/accelerated.sh
        adb reboot &
        sleep 1
        adb disconnect
    done
else
    echo 'What device am I querying'
fi

