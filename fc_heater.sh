#!/bin/sh

# Ask user if set current time to UUT is applicable
echo "Check FAILED cases? y or n, followed by [ENTER]:"
read test_mode
if [ "$test_mode" = "y" ]
then
    heater_setpoint=0

    max_voltage=0
    min_voltage=0

    max_wifipwr=0
    min_wifipwr=0
    max_bcmpwr=0
    min_bcmpwr=0
    max_imxpwr=0
    min_imxpwr=0

    fram1_value=24c
    fram2_value=dumy
    fram3_value=dumy
    fram4_value=dumy

    pcie_value=5
    usb_value=3
else
    heater_setpoint=40

    max_voltage=5250
    min_voltage=4750

    max_wifipwr=400000
    min_wifipwr=300000
    max_bcmpwr=10000000
    min_bcmpwr=9000000
    max_imxpwr=11000000
    min_imxpwr=10000000

    fram1_value=24c08
    fram2_value=dummy
    fram3_value=dummy
    fram4_value=dummy

    pcie_value=7
    usb_value=4
fi

# Constants (can change pending on the UUT)
sampling_rate=5
cycle_count=1

echo `cat /proc/version`
echo "\n"
echo "Begin functional checks"
echo "Heater setpoint is set to $heater_setpoint c"
echo "Press [CTRL+C] to stop the functional checks.."
echo "\n"
# Ask user if set current time to UUT is applicable
echo "Would you like to update the system time? y or n, followed by [ENTER]:"
read update_time
if [ "$update_time" = "y" ]
then
    echo "Type the in this format [date month year hour:min:sec] (eg. 30 OCT 2016 10:30:00), followed by [ENTER]:"
    read current_time
    date --set="$current_time"
fi

while true
do
    NOW=$(date +"%m-%d-%Y %r")
    echo "\n"
    echo "===== Cycle $cycle_count started on $NOW ====="

    # Heater Control
    u147=$(cat /sys/class/hwmon/hwmon3/device/temp1_input)
    u152=$(cat /sys/class/hwmon/hwmon5/device/temp1_input)
    u151=$(cat /sys/class/hwmon/hwmon4/device/temp1_input)
    u148=$(cat /sys/class/hwmon/hwmon6/device/temp1_input)
    u153=$(cat /sys/class/hwmon/hwmon8/device/temp1_input)
    u150=$(cat /sys/class/hwmon/hwmon7/device/temp1_input)
    internal=$(cat /sys/class/hwmon/hwmon9/temp1_input)

    total=$(($u147+$u152+$u151+$u148+$u153+$u150))
    var=$(($total/6000))
    echo " "
    if [ "$var" -gt "$heater_setpoint" ]
    then
        echo "Turning off board heaters.\n"
        echo 1 > /sys/class/gpio/gpio17/value
        echo "\033[32mAverage temperature reading is $var c\033[0m"
    else
        echo "Turning on board heaters.\n"
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

    # Power Monitoring
    # TODO: find max power draw and check against that. 
    echo "\n"
    echo "**Checking power monitors**"
    wifi_ina226_curr=$(cat /sys/class/hwmon/hwmon0/curr1_input)
    wifi_ina226_volt=$(cat /sys/class/hwmon/hwmon0/in1_input)
    wifi_ina226_pow=$(cat /sys/class/hwmon/hwmon0/power1_input)
    bcm_ina226_curr=$(cat /sys/class/hwmon/hwmon2/curr1_input)
    bcm_ina226_volt=$(cat /sys/class/hwmon/hwmon2/in1_input)
    bcm_ina226_pow=$(cat /sys/class/hwmon/hwmon2/power1_input)
    imx_ina226_curr=$(cat /sys/class/hwmon/hwmon1/curr1_input)
    imx_ina226_volt=$(cat /sys/class/hwmon/hwmon1/in1_input)
    imx_ina226_pow=$(cat /sys/class/hwmon/hwmon1/power1_input)

    if [ "$wifi_ina226_volt" -gt "$max_voltage" ] || [ "$wifi_ina226_volt" -lt "$min_voltage" ]
    then
        echo "\033[31;5;7mFAILED: wifi voltage is outside the voltage tolerance of $(($min_voltage)) mV to $(($max_voltage)) mV\033[0m"
        echo "wifi voltage is $(($wifi_ina226_volt)) mV"
    else
        echo "\033[32mPASSED: wifi voltage is within the voltage tolerance @ $(($wifi_ina226_volt)) mV\033[0m"
    fi

    if [ "$wifi_ina226_pow" -gt "$max_wifipwr" ] || [ "$wifi_ina226_pow" -lt "$min_wifipwr" ]
    then
        echo "\033[31;5;7mFAILED: wifi power is outside the power tolerance of $(($min_wifipwr)) mW to $(($max_wifipwr)) mW\033[0m"
        echo "wifi current is $(($wifi_ina226_curr)) mA"
        echo "wifi power is $(($wifi_ina226_pow/1000)) mW"
    else
        echo "\033[32mPASSED: wifi power is within the power tolerance @ $(($wifi_ina226_pow/1000)) mW\033[0m"
    fi


    if [ "$bcm_ina226_volt" -gt "$max_voltage" ] || [ "$bcm_ina226_volt" -lt "$min_voltage" ]
    then
        echo "\033[31;5;7mFAILED: bcm voltage is outside the voltage tolerance of $(($min_voltage)) mV to $(($max_voltage)) mV\033[0m"
        echo "bcm voltage is $(($bcm_ina226_volt)) mV"
    else
        echo "\033[32mPASSED: bcm voltage is within the voltage tolerance @ $(($bcm_ina226_volt)) mV\033[0m"
    fi

    if [ "$bcm_ina226_pow" -gt "$max_bcmpwr" ] || [ "$bcm_ina226_pow" -lt "$min_bcmpwr" ]
    then
        echo "\033[31;5;7mFAILED: bcm power is outside the power tolerance of $(($min_bcmpwr)) mW to $(($max_bcmpwr)) mW\033[0m"
        echo "bcm current is $(($bcm_ina226_curr)) mA"
        echo "bcm power is $(($bcm_ina226_pow/1000)) mW"
    else
        echo "\033[32mPASSED: bcm power is within the power tolerance @ $(($bcm_ina226_pow/1000)) mW\033[0m"
    fi


    if [ "$imx_ina226_volt" -gt "$max_voltage" ] || [ "$imx_ina226_volt" -lt "$min_voltage" ]
    then
        echo "\033[31;5;7mFAILED: imx voltage is outside the voltage tolerance of $(($min_voltage)) mV to $(($max_voltage)) mV\033[0m"
        echo "imx voltage is $(($imx_ina226_volt)) mV"
    else
        echo "\033[32mPASSED: imx voltage is within the voltage tolerance @ $(($imx_ina226_volt)) mV\033[0m"
    fi

    if [ "$imx_ina226_pow" -gt "$max_imxpwr" ] || [ "$imx_ina226_pow" -lt "$min_imxpwr" ]
    then
        echo "\033[31;5;7mFAILED: imx power is outside the power tolerance of $(($min_imxpwr)) mW to $(($max_imxpwr)) mW\033[0m"
        echo "imx current is $(($imx_ina226_curr)) mA"
        echo "imx power is $(($imx_ina226_pow/1000)) mW"
    else
        echo "\033[32mPASSED: imx power is within the power tolerance @ $(($imx_ina226_pow/1000)) mW\033[0m"
    fi

    #FRAM Tests
    echo "\n"
    echo "**Checking FRAM contents**"
    imx_fram1=$(cat /sys/bus/i2c/devices/0-0050/name)
    imx_fram2=$(cat /sys/bus/i2c/devices/0-0051/name)
    imx_fram3=$(cat /sys/bus/i2c/devices/0-0052/name)
    imx_fram4=$(cat /sys/bus/i2c/devices/0-0052/name)
    
    if [ "$imx_fram1" = "$fram1_value" ]
    then
        echo "\033[32mPASSED: iMX FRAM 0x50 reads $imx_fram1\033[0m"
    else
        echo "\033[31;5;7mFAILED: iMX FRAM 0x50 reads $imx_fram1, where it should be $fram1_value\033[0m"
    fi

    if [ "$imx_fram2" = "$fram2_value" ]
    then
        echo "\033[32mPASSED: iMX FRAM 0x51 reads $imx_fram2\033[0m"
    else
        echo "\033[31;5;7mFAILED: iMX FRAM 0x51 reads $imx_fram2, where it should be $fram2_value\033[0m"
    fi

    if [ "$imx_fram3" = "$fram3_value" ]
    then
        echo "\033[32mPASSED: iMX FRAM 0x52 reads $imx_fram3\033[0m"
    else
        echo "\033[31;5;7mFAILED: iMX FRAM 0x52 reads $imx_fram3, where it should be $fram3_value\033[0m"
    fi

    if [ "$imx_fram4" = "$fram4_value" ]
    then
        echo "\033[32mPASSED: iMX FRAM 0x53 reads $imx_fram4\033[0m"
    else
        echo "\033[31;5;7mFAILED: iMX FRAM 0x53 reads $imx_fram4, where it should be $fram4_value\033[0m"
    fi

    # PCIe Tests
    echo "\n"
    echo "**Checking PCIe Device Counts**"
    pcie_count=`lspci | awk 'END{print FNR}'`
    if [ "$pcie_count" -eq "$pcie_value" ]
    then
        echo "\033[32mPASSED: PCIe Count is $pcie_count\033[0m"
    else
        echo "\033[31;5;7mFAILED: PCIe Count is $pcie_count, where it should be: $pcie_value\033[0m"
    fi

    # USB Tests
    echo "\n"
    echo "**Checking USB Device Counts**"
    usb_count=`lsusb | awk 'END{print FNR}'`
    if [ "$usb_count" -eq "$usb_value" ]
    then
        echo "\033[32mPASSED: USB Count is $usb_count\033[0m"
    else
        echo "\033[31;5;7mFAILED: USB Count is $usb_count, where it should be: $usb_value\033[0m"
    fi

    ### Long Duration Testing ###

    # SATA Tests ( Test Time = )
    echo "\n"
    echo "**Checking mSATA speed**"
    echo `hdparm -Tt /dev/sda`
    echo `hdparm -Tt /dev/sda`
    echo `hdparm -Tt /dev/sda`

    echo "\n"
    echo "**Checking eMMC speed**"
    echo `hdparm -Tt /dev/mmcblk0`
    echo `hdparm -Tt /dev/mmcblk0`
    echo `hdparm -Tt /dev/mmcblk0`

    #echo "\n"
    #echo "**Checking mSATA read & write**"
    #echo `smartctl -t long /dev/sda`

    #echo "**Checking smartctl result**"
    #echo `smartctl -l selftest /dev/sda`

    # DDR Tests ( Test Time = ?? estimated 30 min )
    #echo "\n"
    #echo "**Start memtester**"
    # RAM max out at 1899MB, other spaces taken up by OS and tasks
    # Usage: memtester <memory_in_MB> <iterations>
    #echo `memtester 1024 1`
    
    # CPU Test ( Test Time = 60 seconds )
    echo "\n"
    echo "**Start stress-ng**"
    echo "Run for 60 seconds with 4 cpu stressors, 2 io stressors and 1 vm stressor using 1GB of virtual memory"
    echo `stress-ng --cpu 4 --io 2 --vm 1 --vm-bytes 1G --timeout 60s --metrics-brief`

    # Increments cycle count
    cycle_count=$(($cycle_count+1))
    sleep $sampling_rate
done
