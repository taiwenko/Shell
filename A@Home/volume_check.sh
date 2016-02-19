#!/bin/bash
COUNTER=0

adb disconnect
if [ -n "$2" ]
then
    for COUNTER in `seq $1 $2`; do
        adb connect alt$COUNTER:4321
        echo -n "$COUNTER: " 
        adb wait-for-device shell cat /d/tas5713-4-001b/dump_regs | grep "Master volume"
        adb disconnect
    done
else
    echo 'What device am I querying'
fi

