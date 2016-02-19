#!/bin/sh

if [ -n "$1" ]
then

    # make sure device is fully booted before starting
    echo 'Connecting to device'
    adb connect $1:4321
    adb wait-for-device
    adb root
    adb connect $1:4321

    # need to double background because adb can't exit when a process is still
    # running, even if it's in the background.  the host adb will self exit
    # when device disconnects, but leave dhrystone running.
    echo 'Starting dhrystone in background'
    adb wait-for-device shell '/system/bin/dhrystone &' &

    # start thermal monitor with the commands you want
    echo 'Starting thermal monitor'
    adb wait-for-device shell '/system/bin/thermal_monitor &' &

    # start visualizer in stress mode
    echo 'Starting Visualizer in debug mode'   
    adb shell am start -f 0x00008000 -a visualizer.action.DEBUG --ez visual_diagnostics TRUE --ez cpu_saturate TRUE com.android.tungsten.visualizer

    # disconnect from the device
    echo 'Disconnecting'
    adb disconnect

else
    echo 'What device am I starting?'
fi
