#!/bin/sh

# Constants (can change pending on the UUT)
sampling_rate=5
cycle_count=1

echo `version`
echo "Begin functional checks"
echo "Press [CTRL+C] to stop the functional checks.."
# Ask user if set current time to UUT is applicable
echo "Would you like to update the system time? y or n, followed by [ENTER]:"
read update_time
if [ "$update_time" = "y" ]
then
    echo "Type the in this format [MM][DD][HH][MM][YY] (eg. 1004051216), followed by [ENTER]:"
    read current_time
    date "$current_time"
fi

while true
do
    NOW=`date`
    echo "\n"
    echo "===== Cycle $cycle_count started on $NOW ====="

    # BCM53344 Surface Temp
    echo `-e "\nshow temp" | nc localhost 1958 | grep average`
    echo `-e "\nshow temp" | nc localhost 1958 | grep maximum`

    # I2C Test
    echo "\n"
    echo "**Checking I2C Device Counts**"
    i2c_count=`i2c | awk '{print $3 "\t" $4}'`
    if [ "$i2c_count" -eq "$i2c_value" ]
    then
        echo "\033[32mPASSED: I2C Count is $i2c_count\033[0m"
    else
        echo "\033[31;5;7mFAILED: I2C Count is $i2c_count, where it should be: $i2c_value\033[0m"
    fi

    # Port Test

    ### Long Duration Testing ###

    echo `-e "\ntr 21" | nc localhost 1958`

    # Increments cycle count
    cycle_count=$(($cycle_count+1))
    sleep $sampling_rate
done
