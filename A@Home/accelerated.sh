#!/system/bin/sush
# Note "sush" above.  To create sush (and also a gaping security hole) do:
#   adb shell cat /system/bin/sh \> /system/bin/sush
#   adb shell chmod 4755 /system/bin/sush

# Add entry to log file
log -p e -t $0 $(date)

# Start Visualizer in debug mode
am start -f 0x00008000 -a visualizer.action.DEBUG \
--ez visual_diagnostics TRUE \
--ez cpu_saturate TRUE com.android.tungsten.visualizer

# Set the LEDs to a test pattern value
sleep 10
led_test 0x808080
sleep 10
led_test 0x808080
sleep 10
led_test 0x808080
sleep 10
led_test 0x808080
sleep 10
led_test 0x808080

# Start StressAppTest
stressapptest -A -M 256 -s 0x3FFFFFFF -m 2 &

# Start log monitor for failure analysis
    log_monitor -f '%s_kmsg' < /proc/kmsg &
    logcat | log_monitor -f '%s_logcat' &

# Start thermal monitor and reboot if it crashes
( trap 'exit' CHLD; thermal_monitor & wait)

# Log the crash and reboot
log -p e -t $0 $(date) Program exited.  Rebooting.
reboot

