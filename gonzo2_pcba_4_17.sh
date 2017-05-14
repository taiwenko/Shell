#!/bin/sh
set -e
# Constants
max_voltage=5250
min_voltage=4750

max_wifipwr=1300000
min_wifipwr=100000
max_bcmpwr=11000000
min_bcmpwr=7000000
max_imxpwr=12500000
min_imxpwr=7000000

fram1_value=24c08
fram2_value=dummy
fram3_value=dummy
fram4_value=dummy

pcie_value=7
usb_value=4
max_failure=0
max_temp=60000
min_temp=20000
heater_temp_diff=2

min_msata_cache=30000
min_msata_device=9000
min_emmc_cache=10000
min_emmc_device=9000

sampling_rate=5
warmup_time=1m
fail_count=0
correct_count=0
max_scan=1

# Ask user if set current time to UUT is applicable
echo "Would you like to update the system time? y or n, followed by [ENTER]:"
read update_time
if [ "$update_time" = "y" ]
then
    echo "Type the time in this format [date month year hour:min:sec] (eg. 30 OCT 2016 10:30:00), followed by [ENTER]:"
    read current_time
    date --set="$current_time"
fi

# Check barcode correctness
while [ "$correct_count" -lt "$max_scan" ]
do
    echo "Please scan in the barcode number, followed by [ENTER]:"
    read barcode
    echo "The barcode scanned is $barcode. Is that correct? y or n, followed by [ENTER]:"
    read feedback
    if [ "$feedback" = "y" ]
    then
        correct_count=1
    fi
done
correct_count=0

# Test: Check barcode correctness
echo "Please enter the tester name, followed by [ENTER]:"
read tester

# Log unit information and test time
echo "========== Gonzo2 PCBA Workflow ==========" | tee -a mfg_pcba_log.txt
NOW=$(date +"%m-%d-%Y %r")
echo "Current Time: $NOW" | tee -a mfg_pcba_log.txt
echo "Tester Name: $tester" | tee -a mfg_pcba_log.txt
echo "Unit Barcode: $barcode" | tee -a mfg_pcba_log.txt
echo "Unit Version:" | tee -a mfg_pcba_log.txt
echo `cat /proc/version` | tee -a mfg_pcba_log.txt
echo "\n" | tee -a mfg_pcba_log.txt

# Test: Check each temperature sensor
echo "*** Checking temperature monitors ***" | tee -a mfg_pcba_log.txt 
u147=$(cat /sys/class/hwmon/hwmon3/temp1_input)
u152=$(cat /sys/class/hwmon/hwmon5/temp1_input)
u151=$(cat /sys/class/hwmon/hwmon4/temp1_input)
u148=$(cat /sys/class/hwmon/hwmon6/temp1_input)
u153=$(cat /sys/class/hwmon/hwmon8/temp1_input)
u150=$(cat /sys/class/hwmon/hwmon7/temp1_input)
internal=$(cat /sys/class/hwmon/hwmon9/temp1_input)

# U147 Temperature Sensor
if [ "$u147" -ge "$max_temp" ] || [ "$u147" -le "$min_temp" ]
then
    echo "\033[31;5;7mFAILED: U147 temperature reading is outside the tolerance of $(($min_temp/1000)) C to $(($max_temp/1000)) C\033[0m" | tee -a mfg_pcba_log.txt
    fail_count=$(($fail_count+1))   
else
    echo "\033[32mPASSED: U147 temperature reading is within the tolerance of $(($min_temp/1000)) C to $(($max_temp/1000)) C\033[0m" | tee -a mfg_pcba_log.txt
fi
echo "U147 temperature reading is $(($u147/1000)) c" | tee -a mfg_pcba_log.txt

# U152 Temperature Sensor
if [ "$u152" -ge "$max_temp" ] || [ "$u152" -le "$min_temp" ]
then
    echo "\033[31;5;7mFAILED: U152 temperature reading is outside the tolerance of $(($min_temp/1000)) C to $(($max_temp/1000)) C\033[0m" | tee -a mfg_pcba_log.txt
    fail_count=$(($fail_count+1)) 
else
    echo "\033[32mPASSED: U152 temperature reading is within the tolerance of $(($min_temp/1000)) C to $(($max_temp/1000)) C\033[0m" | tee -a mfg_pcba_log.txt
fi
echo "U152 temperature reading is $(($u152/1000)) c" | tee -a mfg_pcba_log.txt

# U151 Temperature Sensor
if [ "$u151" -ge "$max_temp" ] || [ "$u151" -le "$min_temp" ]
then
    echo "\033[31;5;7mFAILED: U151 temperature reading is outside the tolerance of $(($min_temp/1000)) C to $(($max_temp/1000)) C\033[0m" | tee -a mfg_pcba_log.txt
    fail_count=$(($fail_count+1)) 
else
    echo "\033[32mPASSED: U151 temperature reading is within the tolerance of $(($min_temp/1000)) C to $(($max_temp/1000)) C\033[0m" | tee -a mfg_pcba_log.txt
fi
echo "U151 temperature reading is $(($u151/1000)) c" | tee -a mfg_pcba_log.txt

# U148 Temperature Sensor
if [ "$u148" -ge "$max_temp" ] || [ "$u148" -le "$min_temp" ]
then
    echo "\033[31;5;7mFAILED: U148 temperature reading is outside the tolerance of $(($min_temp/1000)) C to $(($max_temp/1000)) C\033[0m" | tee -a mfg_pcba_log.txt
    fail_count=$(($fail_count+1)) 
else
    echo "\033[32mPASSED: U148 temperature reading is within the tolerance of $(($min_temp/1000)) C to $(($max_temp/1000)) C\033[0m" | tee -a mfg_pcba_log.txt
fi
echo "U148 temperature reading is $(($u148/1000)) c" | tee -a mfg_pcba_log.txt

# U153 Temperature Sensor
if [ "$u153" -ge "$max_temp" ] || [ "$u153" -le "$min_temp" ]
then
    echo "\033[31;5;7mFAILED: U153 temperature reading is outside the tolerance of $(($min_temp/1000)) C to $(($max_temp/1000)) C\033[0m" | tee -a mfg_pcba_log.txt
    fail_count=$(($fail_count+1)) 
else
    echo "\033[32mPASSED: U153 temperature reading is within the tolerance of $(($min_temp/1000)) C to $(($max_temp/1000)) C\033[0m" | tee -a mfg_pcba_log.txt
fi
echo "U153 temperature reading is $(($u153/1000)) c" | tee -a mfg_pcba_log.txt

# U150 Temperature Sensor
if [ "$u150" -ge "$max_temp" ] || [ "$u150" -le "$min_temp" ]
then
    echo "\033[31;5;7mFAILED: U150 temperature reading is outside the tolerance of $(($min_temp/1000)) C to $(($max_temp/1000)) C\033[0m" | tee -a mfg_pcba_log.txt
    fail_count=$(($fail_count+1)) 
else
    echo "\033[32mPASSED: U150 temperature reading is within the tolerance of $(($min_temp/1000)) C to $(($max_temp/1000)) C\033[0m" | tee -a mfg_pcba_log.txt
fi
echo "U150 temperature reading is $(($u150/1000)) c" | tee -a mfg_pcba_log.txt

# IMX6 Temperature Sensor
if [ "$internal" -ge "$max_temp" ] || [ "$internal" -le "$min_temp" ]
then
    echo "\033[31;5;7mFAILED: IMX6 temperature reading is outside the tolerance of $(($min_temp/1000)) C to $(($max_temp/1000)) C\033[0m" | tee -a mfg_pcba_log.txt
    fail_count=$(($fail_count+1)) 
else
    echo "\033[32mPASSED: IMX6 temperature reading is within the tolerance of $(($min_temp/1000)) C to $(($max_temp/1000)) C\033[0m" | tee -a mfg_pcba_log.txt
fi
echo "Internal IMX6 temperature reading is $(($internal/1000)) c" | tee -a mfg_pcba_log.txt
echo "\n" | tee -a mfg_pcba_log.txt

# Test: Onboard heaters
echo "Turning onboard heaters and let them warm up for $warmup_time seconds....\n" | tee -a mfg_pcba_log.txt
echo 0 > /sys/class/gpio/gpio17/value

sleep $warmup_time

total=$(($u147+$u152+$u151+$u148+$u153+$u150))
old_var=$(($total/6000))

u147=$(cat /sys/class/hwmon/hwmon3/temp1_input)
u152=$(cat /sys/class/hwmon/hwmon5/temp1_input)
u151=$(cat /sys/class/hwmon/hwmon4/temp1_input)
u148=$(cat /sys/class/hwmon/hwmon6/temp1_input)
u153=$(cat /sys/class/hwmon/hwmon8/temp1_input)
u150=$(cat /sys/class/hwmon/hwmon7/temp1_input)
internal=$(cat /sys/class/hwmon/hwmon9/temp1_input)

total=$(($u147+$u152+$u151+$u148+$u153+$u150))
new_var=$(($total/6000))

var=$(($new_var-$old_var))

if [ "$var" -lt "$heater_temp_diff" ]
then
    echo "\033[31;5;7mFAILED: Heaters are not working as expected.\033[0m" | tee -a mfg_pcba_log.txt
    fail_count=$(($fail_count+1)) 
else
    echo "\033[32mPASSED: Heaters are working as expected.\033[0m" | tee -a mfg_pcba_log.txt
fi
echo "Heater temperature difference is $(($var))" | tee -a mfg_pcba_log.txt

echo "Turning off board heaters....\n" | tee -a mfg_pcba_log.txt
echo 1 > /sys/class/gpio/gpio17/value

# Power Monitoring
echo "*** Checking power monitors ***" | tee -a mfg_pcba_log.txt
wifi_ina226_curr=$(cat /sys/class/hwmon/hwmon0/curr1_input)
wifi_ina226_volt=$(cat /sys/class/hwmon/hwmon0/in1_input)
wifi_ina226_pow=$(cat /sys/class/hwmon/hwmon0/power1_input)
bcm_ina226_curr=$(cat /sys/class/hwmon/hwmon2/curr1_input)
bcm_ina226_volt=$(cat /sys/class/hwmon/hwmon2/in1_input)
bcm_ina226_pow=$(cat /sys/class/hwmon/hwmon2/power1_input)
imx_ina226_curr=$(cat /sys/class/hwmon/hwmon1/curr1_input)
imx_ina226_volt=$(cat /sys/class/hwmon/hwmon1/in1_input)
imx_ina226_pow=$(cat /sys/class/hwmon/hwmon1/power1_input)

# Test: Check wifi voltage
if [ "$wifi_ina226_volt" -ge "$max_voltage" ] || [ "$wifi_ina226_volt" -le "$min_voltage" ]
then
    echo "\033[31;5;7mFAILED: wifi voltage is outside the tolerance of $(($min_voltage)) mV to $(($max_voltage)) mV\033[0m" | tee -a mfg_pcba_log.txt
    fail_count=$(($fail_count+1)) 
else
    echo "\033[32mPASSED: wifi voltage is within the tolerance of $(($min_voltage)) mV to $(($max_voltage)) mV\033[0m" | tee -a mfg_pcba_log.txt
fi
echo "wifi voltage is $(($wifi_ina226_volt)) mV" | tee -a mfg_pcba_log.txt

# Test: Check wifi power
if [ "$wifi_ina226_pow" -ge "$max_wifipwr" ] || [ "$wifi_ina226_pow" -le "$min_wifipwr" ]
then
    echo "\033[31;5;7mFAILED: wifi power is outside the power tolerance of $(($min_wifipwr)) uW to $(($max_wifipwr)) uW\033[0m" | tee -a mfg_pcba_log.txt
    fail_count=$(($fail_count+1)) 
else
    echo "\033[32mPASSED: wifi power is within the power tolerance of $(($min_wifipwr)) uW to $(($max_wifipwr)) uW\033[0m" | tee -a mfg_pcba_log.txt
fi
echo "wifi current is $(($wifi_ina226_curr)) mA" | tee -a mfg_pcba_log.txt
echo "wifi power is $(($wifi_ina226_pow/1000)) mW" | tee -a mfg_pcba_log.txt

# Test: Check bcm voltage
if [ "$bcm_ina226_volt" -ge "$max_voltage" ] || [ "$bcm_ina226_volt" -le "$min_voltage" ]
then
    echo "\033[31;5;7mFAILED: bcm voltage is outside the voltage tolerance of $(($min_voltage)) mV to $(($max_voltage)) mV\033[0m" | tee -a mfg_pcba_log.txt
    fail_count=$(($fail_count+1)) 
else
    echo "\033[32mPASSED: bcm voltage is within the voltage tolerance of $(($min_voltage)) mV to $(($max_voltage)) mV\033[0m" | tee -a mfg_pcba_log.txt
fi
echo "bcm voltage is $(($bcm_ina226_volt)) mV" | tee -a mfg_pcba_log.txt

# Test: Check bcm power
if [ "$bcm_ina226_pow" -ge "$max_bcmpwr" ] || [ "$bcm_ina226_pow" -le "$min_bcmpwr" ]
then
    echo "\033[31;5;7mFAILED: bcm power is outside the power tolerance of $(($min_bcmpwr)) uW to $(($max_bcmpwr)) uW\033[0m" | tee -a mfg_pcba_log.txt
    fail_count=$(($fail_count+1))
else
    echo "\033[32mPASSED: bcm power is within the power tolerance of $(($min_bcmpwr)) uW to $(($max_bcmpwr)) uW\033[0m" | tee -a mfg_pcba_log.txt
fi
echo "bcm current is $(($bcm_ina226_curr)) mA" | tee -a mfg_pcba_log.txt
echo "bcm power is $(($bcm_ina226_pow/1000)) mW" | tee -a mfg_pcba_log.txt

# Test: Check imx voltage
if [ "$imx_ina226_volt" -ge "$max_voltage" ] || [ "$imx_ina226_volt" -le "$min_voltage" ]
then
    echo "\033[31;5;7mFAILED: imx voltage is outside the voltage tolerance of $(($min_voltage)) mV to $(($max_voltage)) mV\033[0m" | tee -a mfg_pcba_log.txt
    fail_count=$(($fail_count+1))
else
    echo "\033[32mPASSED: imx voltage is within the voltage tolerance of $(($min_voltage)) mV to $(($max_voltage)) mV\033[0m" | tee -a mfg_pcba_log.txt
fi
echo "imx voltage is $(($imx_ina226_volt)) mV" | tee -a mfg_pcba_log.txt

# Test: Check imx power
if [ "$imx_ina226_pow" -ge "$max_imxpwr" ] || [ "$imx_ina226_pow" -le "$min_imxpwr" ]
then
    echo "\033[31;5;7mFAILED: imx power is outside the power tolerance of $(($min_imxpwr)) uW to $(($max_imxpwr)) uW\033[0m" | tee -a mfg_pcba_log.txt
    fail_count=$(($fail_count+1))
else
    echo "\033[32mPASSED: imx power is within the power tolerance of $(($min_imxpwr)) uW to $(($max_imxpwr)) uW\033[0m" | tee -a mfg_pcba_log.txt
fi
echo "imx current is $(($imx_ina226_curr)) mA" | tee -a mfg_pcba_log.txt
echo "imx power is $(($imx_ina226_pow/1000)) mW" | tee -a mfg_pcba_log.txt    

# Test: Check FRAM Values
echo "\n" | tee -a mfg_pcba_log.txt
echo "*** Checking FRAM contents ***" | tee -a mfg_pcba_log.txt
imx_fram1=$(cat /sys/bus/i2c/devices/0-0050/name)
imx_fram2=$(cat /sys/bus/i2c/devices/0-0051/name)
imx_fram3=$(cat /sys/bus/i2c/devices/0-0052/name)
imx_fram4=$(cat /sys/bus/i2c/devices/0-0052/name)


if [ "$imx_fram1" = "$fram1_value" ]
then
    echo "\033[32mPASSED: iMX FRAM 0x50 reads $imx_fram1\033[0m" | tee -a mfg_pcba_log.txt
else
    echo "\033[31;5;7mFAILED: iMX FRAM 0x50 reads $imx_fram1, where it should be $fram1_value\033[0m" | tee -a mfg_pcba_log.txt
    fail_count=$(($fail_count+1))
fi


if [ "$imx_fram2" = "$fram2_value" ]
then
    echo "\033[32mPASSED: iMX FRAM 0x51 reads $imx_fram2\033[0m" | tee -a mfg_pcba_log.txt
else
    echo "\033[31;5;7mFAILED: iMX FRAM 0x51 reads $imx_fram2, where it should be $fram2_value\033[0m" | tee -a mfg_pcba_log.txt
    fail_count=$(($fail_count+1))
fi


if [ "$imx_fram3" = "$fram3_value" ]
then
    echo "\033[32mPASSED: iMX FRAM 0x52 reads $imx_fram3\033[0m" | tee -a mfg_pcba_log.txt
else
    echo "\033[31;5;7mFAILED: iMX FRAM 0x52 reads $imx_fram3, where it should be $fram3_value\033[0m" | tee -a mfg_pcba_log.txt
    fail_count=$(($fail_count+1))
fi


if [ "$imx_fram4" = "$fram4_value" ]
then
    echo "\033[32mPASSED: iMX FRAM 0x53 reads $imx_fram4\033[0m" | tee -a mfg_pcba_log.txt
else
    echo "\033[31;5;7mFAILED: iMX FRAM 0x53 reads $imx_fram4, where it should be $fram4_value\033[0m" | tee -a mfg_pcba_log.txt
    fail_count=$(($fail_count+1))
fi

# PCIe Tests
echo "\n" | tee -a mfg_pcba_log.txt
echo "*** Checking PCIe Device Counts ***" | tee -a mfg_pcba_log.txt
pcie_count=`lspci | awk 'END{print FNR}'`
if [ "$pcie_count" -eq "$pcie_value" ]
then
    echo "\033[32mPASSED: PCIe Count is $pcie_count\033[0m" | tee -a mfg_pcba_log.txt
else
    echo "\033[31;5;7mFAILED: PCIe Count is $pcie_count, where it should be: $pcie_value\033[0m" | tee -a mfg_pcba_log.txt
    fail_count=$(($fail_count+1))
fi

# USB Tests
echo "\n" | tee -a mfg_pcba_log.txt
echo "*** Checking USB Device Counts ***" | tee -a mfg_pcba_log.txt
usb_count=`lsusb | awk 'END{print FNR}'`
if [ "$usb_count" -eq "$usb_value" ]
then
    echo "\033[32mPASSED: USB Count is $usb_count\033[0m" | tee -a mfg_pcba_log.txt
else
    echo "\033[31;5;7mFAILED: USB Count is $usb_count, where it should be: $usb_value\033[0m" | tee -a mfg_pcba_log.txt
    echo `lsusb`
    fail_count=$(($fail_count+1))
fi

# Count number of failures
echo "\n" | tee -a mfg_pcba_log.txt
if [ "$fail_count" -eq "$max_failure" ]
then
    echo "\033[32mUnit $barcode PASSED all tests\033[0m" | tee -a mfg_pcba_log.txt
else
    echo "\033[31;5;7mUnit $barcode FAILED $fail_count tests\033[0m" | tee -a mfg_pcba_log.txt
fi
fail_count=0

echo "Press [ENTER] to quit the workflow...."
read response
echo "\n" | tee -a mfg_pcba_log.txt









