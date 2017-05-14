#!/bin/sh
main_heater_setpoint=-30
sd_heater_setpoint=-30
sampling_rate=5
while true
do
    # Check main temperature
    u147=$(cat /sys/class/hwmon/hwmon3/temp1_input)
    u152=$(cat /sys/class/hwmon/hwmon5/temp1_input)
    u151=$(cat /sys/class/hwmon/hwmon4/temp1_input)
    u148=$(cat /sys/class/hwmon/hwmon6/temp1_input)
    u153=$(cat /sys/class/hwmon/hwmon8/temp1_input)
    u150=$(cat /sys/class/hwmon/hwmon7/temp1_input)
    internal=$(cat /sys/class/hwmon/hwmon9/temp1_input)

    total=$(($u147+$u152+$u151+$u148+$u153+$u150))
    var=$(($total/6000))

    if [ "$var" -gt "$main_heater_setpoint" ]
    then
        echo "Turning off main heaters.\n"
        echo 1 > /sys/class/gpio/gpio17/value
        echo "\033[32mAverage temperature reading is $var c\033[0m"
    else
        echo "Turning on main heaters.\n"
        echo 0 > /sys/class/gpio/gpio17/value
        echo "\033[31mAverage temperature reading is $var c\033[0m"
    fi

    echo "U147 temperature reading is $(($u147/1000)) c"
    echo "U152 temperature reading is $(($u152/1000)) c"
    echo "U151 temperature reading is $(($u151/1000)) c"
    echo "U148 temperature reading is $(($u148/1000)) c"
    echo "U153 temperature reading is $(($u153/1000)) c"
    echo "U150 temperature reading is $(($u150/1000)) c"
    echo "Internal IMX6 temperature reading is $(($internal/1000)) c"

    # Check sd temperature
    # u150=$(cat /sys/class/hwmon/hwmon7/temp1_input)
    # var=$(($u150/1000))

    #if [ "$var" -gt "$sd_heater_setpoint" ]
    #then
    #    echo "Turning off sd heaters.\n"
    #     echo 1 > /sys/class/gpio/gpio17/value
    #     echo "\033[32mSD card temperature reading is $var c\033[0m"
    # else
    #     echo "Turning on sd heaters.\n"
    #     echo 0 > /sys/class/gpio/gpio17/value
    #     echo "\033[31mSD card temperature reading is $var c\033[0m"
    # fi

    sleep $sampling_rate
done








