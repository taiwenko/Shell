echo "Test Mid PWM"
adb shell "echo 0 > /d/localtime-vcxo/value"
sleep 2
adb shell "echo 1 > /d/localtime-vcxo/factory_test"
sleep 2
adb shell "cat /d/localtime-vcxo/factory_test"

echo "Test Low PWM"
adb shell "echo -32767 > /d/localtime-vcxo/value"
sleep 2
adb shell "echo 1 > /d/localtime-vcxo/factory_test"
sleep 2
adb shell "cat /d/localtime-vcxo/factory_test"

echo "Test High PWM"
adb shell "echo 32767 > /d/localtime-vcxo/value"
sleep 2
adb shell "echo 1 > /d/localtime-vcxo/factory_test"
sleep 2
adb shell "cat /d/localtime-vcxo/factory_test"
