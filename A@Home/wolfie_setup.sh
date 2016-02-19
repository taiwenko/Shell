#!/bin/bash

i=1
rm -f mac_address
while [ "$i" -lt 50 ]
do
    read -p "Press enter to setup device $i"
    n=$(printf %02d $i)
    adb wait-for-device root
    adb wait-for-device remount
    adb wait-for-device push dhrystone /data/local
    adb wait-for-device shell chmod 755 /data/local/dhrystone
    adb wait-for-device shell setprop persist.adb.tcp.port 4321
    echo "host alt$i {" >> mac_address
    echo $'\t'"hardware ethernet "$(adb wait-for-device shell netcfg | grep eth0 | cut -b 72-88)";"  >> mac_address
    echo $'\t'"fixed-address 192.168.0.1$n;" >> mac_address
    echo "}" >> mac_address
    adb reboot
done



