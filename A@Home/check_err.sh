#!/bin/bash

adb disconnect
for i in `seq 1 50`; do
    adb connect alt$i:4321
    adb wait-for-device shell cat /d/tas5713-4-001b/err_reg
    adb disconnect
done
