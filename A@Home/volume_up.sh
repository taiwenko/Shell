#!/bin/bash
adb disconnect
echo "Volume up started..." > volume_up.log
for i in `seq 1 50`; do
    adb connect alt$i:4321
    adb wait-for-device shell input keyevent 24
    for j in `seq 1 15`; do
        adb shell input keyevent 24
        echo $j
    done
    echo -n "$i: " >> volume_up.log
    adb wait-for-device shell cat /d/tas5713-4-001b/dump_regs | grep "Master volume" >> volume_up.log
    adb disconnect
done
