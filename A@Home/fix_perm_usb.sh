#!/bin/bash
COUNTER=0

adb disconnect
echo "Fix permissions started..."
adb wait-for-device root
adb wait-for-device remount
adb wait-for-device shell chown root.root /system/bin/sush
adb wait-for-device shell chown root.root /system/accelerated.sh
adb wait-for-device shell chmod 4755 /system/bin/sush
adb wait-for-device shell chmod 755 /system/accelerated.sh
adb reboot &
sleep 1

