#!/bin/bash
adb disconnect
for i in `seq 101 150`; do
    res=`adb connect 192.168.0.$i:4321`
    foo=`expr match "$res" "connected"`
    if [[ $foo -eq 9 ]]; then
        adb wait-for-device
        echo -n "Unit $i, temp: "
        echo -n `adb shell cat /sys/devices/platform/omap/omap_temp_sensor.0/temp1_input`
    else
        echo "Cannot connect to 192.168.0.$i:4321"
    fi
    adb disconnect
done
