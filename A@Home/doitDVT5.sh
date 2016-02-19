#!/bin/sh

if [ -n "$1" ]
then
    #make sure device is fully booted before starting
    echo 'Connecting to device'
    adb connect $1:4321
    adb wait-for-device
    adb root
    sleep 1
    adb connect $1:4321
    adb wait-for-device
    adb remount
    adb wait-for-device
    adb shell mkdir -p /system/test_media
    echo 'Pushing MP3 file'
    adb push test.mp3 /system/test_media/
    echo 'Pushing Thermal Monitor'
    adb push thermal_monitor /system/bin
    adb push log_monitor /system/bin
    echo 'Pushing StressAppTest'
    adb push stressapptest /system/bin
    echo 'Pushing LED control override file'
    adb push com.android.athome.broker.config.txt /system/etc/
    echo 'Setting execution bits for thermal & log monitor and StressAppTest'
    adb shell chmod 755 /system/bin/thermal_monitor
    adb shell chmod 755 /system/bin/log_monitor
    adb shell chmod 755 /system/bin/stressapptest
    echo 'Pushing audio stress test APK'
    adb push audio_stress_test.apk /system/app/
    echo 'Setting audio stress test properties'
    adb shell setprop persist.ast.led_color FFFFFF
    echo 'Setting thermal monitor properties'
    adb shell setprop persist.tmon.addr 192.168.0.1
    adb shell setprop persist.tmon.interval 60000
    adb shell setprop persist.lmon.addr 192.168.0.1
    echo 'Setting start on reboot commands'
    adb push Accelerated.apk /system/app
    adb push accelerated.sh /system
    adb shell chmod 755 /system/accelerated.sh
    adb shell cat /system/bin/sh \> /system/bin/sush
    adb shell chmod 4755 /system/bin/sush
    echo 'Rebooting'
    adb reboot &
    echo 'Done with this device'
    adb disconnect

else
    echo 'What device am I setting up?'
fi

