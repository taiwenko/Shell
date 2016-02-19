#!/bin/bash

adb disconnect
for i in `seq 18 20`; do
    adb connect alt$i:4321
    adb wait-for-device root
    sleep 1
    adb connect alt$i:4321
    adb wait-for-device remount
    adb wait-for-device push accelerated.sh /system/
    adb wait-for-device shell chmod 755 /system/accelerated.sh
    adb wait-for-device push audio_stress_test.apk /system/app/
    adb wait-for-device shell setprop persist.ast.led_color 808080
    adb wait-for-device shell "reboot &" &
    sleep 1
    adb disconnect
done
