echo "Please scan in the Gonzo2 QR code"
read label
if [ "${label:0:9}" = "650-00953" ] && [ "${label:15:2}" = "NR" ]
then
	echo "Please enter in the MAC Address"
	read mac
	if [ "${mac:2:1}" = ":" ] && [ "${mac:5:1}" = ":" ] && [ "${mac:8:1}" = ":" ] && [ "${mac:11:1}" = ":" ] && [ "${mac:14:1}" = ":" ] 
	then	
		echo "Please copy this and paste it to Gonzod"
		echo ""
		echo "gonzo fram gsn=${label:0:12} gpn=${label:13:13} mac=${mac:0:18}"
		echo ""
	else
		echo "The mac address has an incorrect format: $mac"
		echo "The correct format should be: ##:##:##:##:##:##"
	fi
else
 	echo "The scanned label has an incorrect format: $label"
 	echo "The correct format should be: 650-00953-## ##NR#########"
fi

