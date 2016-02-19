#!/bin/bash
COUNTER=0

adb disconnect
if [ -n "$2" ]
then
    mkdir -p volume
    NOW=$(date +%Y_%m_%d_%H_%M_%S)
    DIRECTORY=./volume/volume_up_sel_$NOW.log
    echo "Volume up started..." > $DIRECTORY
    for COUNTER in `seq $1 $2`; do
        adb connect alt$COUNTER:4321
        echo -n "ALT$COUNTER: " >> $DIRECTORY
        vol_start=`adb wait-for-device shell cat /d/tas5713-4-001b/dump_regs | grep "Master volume" | cut -c 21- | awk '{ print $4 }' | sed -e 's///'`
        echo "Volume start: $vol_start" | tee -a $DIRECTORY
        if [ $vol_start == "2b" ]; then
            echo "Equals 2b, try down tick"
            adb wait-for-device shell input keyevent 25
        else
            echo "Below 2b, try up tick"
            adb wait-for-device shell input keyevent 24
        fi
        vol_now=`adb wait-for-device shell cat /d/tas5713-4-001b/dump_regs | grep "Master volume" | cut -c 21- | awk '{ print $4 }' | sed -e 's///'`
        if [ $vol_now == $vol_start ]; then
            echo "Turning off mute"
            adb wait-for-device shell input keyevent 164
        fi
        while [ $vol_now != "2b" ]; do
            adb shell input keyevent 24
            vol_now=`adb wait-for-device shell cat /d/tas5713-4-001b/dump_regs | grep "Master volume" | cut -c 21- | awk '{ print $4 }' | sed -e 's///'`
            echo "Volume now: $vol_now"
        done
        echo -n "ALT$COUNTER: " >> $DIRECTORY
        adb wait-for-device shell cat /d/tas5713-4-001b/dump_regs | grep "Master volume" | cut -c 21- | tee -a $DIRECTORY
        adb disconnect
    done
else
    echo 'What device am I querying'
fi

