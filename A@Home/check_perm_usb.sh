#!/bin/bash
COUNTER=0

adb disconnect
echo "Check permissions started..."
adb wait-for-device shell ls -la /system/bin/sush
adb wait-for-device shell getprop ro.build.id
adb wait-for-device shell getprop ro.serialno
adb wait-for-device shell ls -la /system/bin/thermal_monitor

