#!/bin/sh
#set -x
# Ask user if set current time to UUT is applicable
echo "Check FAILED cases? y or n, followed by [ENTER]:" | tee -a tc_log.txt
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

    pcie_value=4
    usb_value=3
else
    heater_setpoint=-10
    max_voltage=5250
    min_voltage=4750

    max_wifipwr=400000
    min_wifipwr=300000
    max_bcmpwr=11000000
    min_bcmpwr=10000000
    max_imxpwr=11000000
    min_imxpwr=10000000

    fram1_value=24c08
    fram2_value=dummy
    fram3_value=dummy
    fram4_value=dummy

    pcie_value=6
    usb_value=5
fi

# Constants (can change pending on the UUT)
sampling_rate=5
cycle_count=1

echo `cat /proc/version` | tee -a tc_log.txt
echo "\n" | tee -a tc_log.txt
echo "Begin functional checks" | tee -a tc_log.txt
echo "Heater setpoint is set to $heater_setpoint c" | tee -a tc_log.txt
echo "Press [CTRL+C] to stop the functional checks.."
echo "\n" | tee -a tc_log.txt

# Ask user if set current time to UUT is applicable
echo "Would you like to update the system time? y or n, followed by [ENTER]:" | tee -a tc_log.txt
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
    echo "\n" | tee -a tc_log.txt
    echo "===== Cycle $cycle_count started on $NOW =====" | tee -a tc_log.txt

    # Heater Control
    u147=$(cat /sys/class/hwmon/hwmon3/temp1_input)
    u152=$(cat /sys/class/hwmon/hwmon5/temp1_input)
    u151=$(cat /sys/class/hwmon/hwmon4/temp1_input)
    u148=$(cat /sys/class/hwmon/hwmon6/temp1_input)
    u153=$(cat /sys/class/hwmon/hwmon8/temp1_input)
    u150=$(cat /sys/class/hwmon/hwmon7/temp1_input)
    internal=$(cat /sys/class/hwmon/hwmon9/temp1_input)

    total=$(($u147+$u152+$u151+$u148+$u153+$u150))
    var=$(($total/6000))
    echo " " | tee -a tc_log.txt
    if [ "$var" -gt "$heater_setpoint" ]
    then
        echo "Turning off board heaters.\n" | tee -a tc_log.txt
        echo 1 > /sys/class/gpio/gpio17/value
        echo "\033[32mAverage temperature reading is $var c\033[0m" | tee -a tc_log.txt
    else
        echo "Turning on board heaters.\n" | tee -a tc_log.txt
        echo 0 > /sys/class/gpio/gpio17/value
        echo "\033[31mAverage temperature reading is $var c\033[0m" | tee -a tc_log.txt
    fi
    echo "U147 temperature reading is $(($u147/1000)) c" | tee -a tc_log.txt
    echo "U152 temperature reading is $(($u152/1000)) c" | tee -a tc_log.txt
    echo "U151 temperature reading is $(($u151/1000)) c" | tee -a tc_log.txt
    echo "U148 temperature reading is $(($u148/1000)) c" | tee -a tc_log.txt
    echo "U153 temperature reading is $(($u153/1000)) c" | tee -a tc_log.txt
    echo "U150 temperature reading is $(($u150/1000)) c" | tee -a tc_log.txt
    echo "Internal IMX6 temperature reading is $(($internal/1000)) c" | tee -a tc_log.txt


    # Power Monitoring
    # TODO: find max power draw and check against that. 
    echo "\n" | tee -a tc_log.txt
    echo "**Checking power monitors**" | tee -a tc_log.txt
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
        echo "\033[31;5;7mFAILED: wifi voltage is outside the voltage tolerance of $(($min_voltage)) mV to $(($max_voltage)) mV\033[0m" | tee -a tc_log.txt
        echo "wifi voltage is $(($wifi_ina226_volt)) mV" | tee -a tc_log.txt
    else
        echo "\033[32mPASSED: wifi voltage is within the voltage tolerance @ $(($wifi_ina226_volt)) mV\033[0m" | tee -a tc_log.txt
    fi

    if [ "$wifi_ina226_pow" -gt "$max_wifipwr" ] || [ "$wifi_ina226_pow" -lt "$min_wifipwr" ]
    then
        echo "\033[31;5;7mFAILED: wifi power is outside the power tolerance of $(($min_wifipwr)) uW to $(($max_wifipwr)) uW\033[0m" | tee -a tc_log.txt
        echo "wifi current is $(($wifi_ina226_curr)) mA" | tee -a tc_log.txt
        echo "wifi power is $(($wifi_ina226_pow/1000)) mW" | tee -a tc_log.txt
    else
        echo "\033[32mPASSED: wifi power is within the power tolerance @ $(($wifi_ina226_pow/1000)) mW\033[0m" | tee -a tc_log.txt
    fi


    if [ "$bcm_ina226_volt" -gt "$max_voltage" ] || [ "$bcm_ina226_volt" -lt "$min_voltage" ]
    then
        echo "\033[31;5;7mFAILED: bcm voltage is outside the voltage tolerance of $(($min_voltage)) mV to $(($max_voltage)) mV\033[0m" | tee -a tc_log.txt
        echo "bcm voltage is $(($bcm_ina226_volt)) mV" | tee -a tc_log.txt
    else
        echo "\033[32mPASSED: bcm voltage is within the voltage tolerance @ $(($bcm_ina226_volt)) mV\033[0m" | tee -a tc_log.txt
    fi


    if [ "$bcm_ina226_pow" -gt "$max_bcmpwr" ] || [ "$bcm_ina226_pow" -lt "$min_bcmpwr" ]
    then
        echo "\033[31;5;7mFAILED: bcm power is outside the power tolerance of $(($min_bcmpwr)) uW to $(($max_bcmpwr)) uW\033[0m" | tee -a tc_log.txt
        echo "bcm current is $(($bcm_ina226_curr)) mA" | tee -a tc_log.txt
        echo "bcm power is $(($bcm_ina226_pow/1000)) mW" | tee -a tc_log.txt
    else
        echo "\033[32mPASSED: bcm power is within the power tolerance @ $(($bcm_ina226_pow/1000)) mW\033[0m" | tee -a tc_log.txt
    fi


    if [ "$imx_ina226_volt" -gt "$max_voltage" ] || [ "$imx_ina226_volt" -lt "$min_voltage" ]
    then
        echo "\033[31;5;7mFAILED: imx voltage is outside the voltage tolerance of $(($min_voltage)) mV to $(($max_voltage)) mV\033[0m" | tee -a tc_log.txt
        echo "imx voltage is $(($imx_ina226_volt)) mV" | tee -a tc_log.txt
    else
        echo "\033[32mPASSED: imx voltage is within the voltage tolerance @ $(($imx_ina226_volt)) mV\033[0m" | tee -a tc_log.txt
    fi


    if [ "$imx_ina226_pow" -gt "$max_imxpwr" ] || [ "$imx_ina226_pow" -lt "$min_imxpwr" ]
    then
        echo "\033[31;5;7mFAILED: imx power is outside the power tolerance of $(($min_imxpwr)) uW to $(($max_imxpwr)) uW\033[0m" | tee -a tc_log.txt
        echo "imx current is $(($imx_ina226_curr)) mA" | tee -a tc_log.txt
        echo "imx power is $(($imx_ina226_pow/1000)) mW" | tee -a tc_log.txt
    else
        echo "\033[32mPASSED: imx power is within the power tolerance @ $(($imx_ina226_pow/1000)) mW\033[0m" | tee -a tc_log.txt
    fi

    sleep $sampling_rate
    sleep $sampling_rate

    #FRAM Tests
    echo "\n" | tee -a tc_log.txt
    echo "**Checking FRAM contents**" | tee -a tc_log.txt
    imx_fram1=$(cat /sys/bus/i2c/devices/0-0050/name)
    imx_fram2=$(cat /sys/bus/i2c/devices/0-0051/name)
    imx_fram3=$(cat /sys/bus/i2c/devices/0-0052/name)
    imx_fram4=$(cat /sys/bus/i2c/devices/0-0052/name)


    if [ "$imx_fram1" = "$fram1_value" ]
    then
        echo "\033[32mPASSED: iMX FRAM 0x50 reads $imx_fram1\033[0m" | tee -a tc_log.txt
    else
        echo "\033[31;5;7mFAILED: iMX FRAM 0x50 reads $imx_fram1, where it should be $fram1_value\033[0m" | tee -a tc_log.txt
    fi


    if [ "$imx_fram2" = "$fram2_value" ]
    then
        echo "\033[32mPASSED: iMX FRAM 0x51 reads $imx_fram2\033[0m" | tee -a tc_log.txt
    else
        echo "\033[31;5;7mFAILED: iMX FRAM 0x51 reads $imx_fram2, where it should be $fram2_value\033[0m" | tee -a tc_log.txt
    fi


    if [ "$imx_fram3" = "$fram3_value" ]
    then
        echo "\033[32mPASSED: iMX FRAM 0x52 reads $imx_fram3\033[0m" | tee -a tc_log.txt
    else
        echo "\033[31;5;7mFAILED: iMX FRAM 0x52 reads $imx_fram3, where it should be $fram3_value\033[0m" | tee -a tc_log.txt
    fi


    if [ "$imx_fram4" = "$fram4_value" ]
    then
        echo "\033[32mPASSED: iMX FRAM 0x53 reads $imx_fram4\033[0m" | tee -a tc_log.txt
    else
        echo "\033[31;5;7mFAILED: iMX FRAM 0x53 reads $imx_fram4, where it should be $fram4_value\033[0m" | tee -a tc_log.txt
    fi


    # PCIe Tests
    echo "\n" | tee -a tc_log.txt
    echo "**Checking PCIe Device Counts**" | tee -a tc_log.txt
    pcie_count=`lspci | awk 'END{print FNR}'`
    if [ "$pcie_count" -eq "$pcie_value" ]
    then
        echo "\033[32mPASSED: PCIe Count is $pcie_count\033[0m" | tee -a tc_log.txt
    else
        echo "\033[31;5;7mFAILED: PCIe Count is $pcie_count, where it should be: $pcie_value\033[0m" | tee -a tc_log.txt
    fi


    # USB Tests
    echo "\n" | tee -a tc_log.txt
    echo "**Checking USB Device Counts**" | tee -a tc_log.txt
    usb_count=`lsusb | awk 'END{print FNR}'`
    if [ "$usb_count" -eq "$usb_value" ]
    then
        echo "\033[32mPASSED: USB Count is $usb_count\033[0m" | tee -a tc_log.txt
    else
        echo "\033[31;5;7mFAILED: USB Count is $usb_count, where it should be: $usb_value\033[0m" | tee -a tc_log.txt
    fi


    ### Long Duration Testing ###


    # SATA Tests ( Test Time = )
    echo "\n" | tee -a tc_log.txt
    echo "**Checking mSATA speed**" | tee -a tc_log.txt
    echo `hdparm -Tt /dev/sda` | tee -a tc_log.txt
    echo `hdparm -Tt /dev/sda` | tee -a tc_log.txt
    echo `hdparm -Tt /dev/sda` | tee -a tc_log.txt


    echo "\n" | tee -a tc_log.txt
    echo "**Checking eMMC speed**" | tee -a tc_log.txt
    echo `hdparm -Tt /dev/mmcblk0` | tee -a tc_log.txt
    echo `hdparm -Tt /dev/mmcblk0` | tee -a tc_log.txt
    echo `hdparm -Tt /dev/mmcblk0` | tee -a tc_log.txt


    # echo "\n" | tee -a tc_log.txt
    # echo "**Checking mSATA read & write**" | tee -a tc_log.txt
    # echo `smartctl -t long /dev/sda`


    # echo "**Checking smartctl result**" | tee -a tc_log.txt
    # echo `smartctl -l selftest /dev/sda`


    # DDR Tests ( Test Time = ?? estimated 30 min )
    # echo "\n" | tee -a tc_log.txt
    # echo "**Start memtester**" | tee -a tc_log.txt
    # RAM max out at 1899MB, other spaces taken up by OS and tasks
    # Usage: memtester <memory_in_MB> <iterations>
    # echo `memtester 1024 1`

    # CPU Test ( Test Time = 60 seconds )
    # echo "\n" | tee -a tc_log.txt
    # echo "**Start stress-ng**" | tee -a tc_log.txt
    # echo "Run for 60 seconds with 4 cpu stressors, 2 io stressors and 1 vm stressor using 1GB of virtual memory" | tee -a tc_log.txt
    # echo `stress-ng --cpu 4 --io 2 --vm 1 --vm-bytes 1G --timeout 60s --metrics-brief`
    # Increments cycle count
    cycle_count=$(($cycle_count+1))
    sleep $sampling_rate
done








