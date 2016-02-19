#!/bin/sh

COUNTER=0
while [  $COUNTER -lt 50 ]; do
    COUNTER=$(( $COUNTER + 1))
    echo 'Checking ALT'$COUNTER
    adb connect alt$COUNTER:4321
    adb disconnect
done
