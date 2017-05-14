echo "Please scan in the Gonzo2 QR code"
read label
if [ "${label:0:9}" = "650-00953" ] && [ "${label:15:2}" = "NR" ] && [ "${label:29:1}" = ":" ] && [ "${label:32:1}" = ":" ] && [ "${label:35:1}" = ":" ] && [ "${label:38:1}" = ":" ] && [ "${label:41:1}" = ":" ] 
then
 echo "Please copy this and paste it to Gonzod"
 echo ""
 echo "gonzo fram gsn=${label:0:12} gpn=${label:13:13} mac=${label:27:18}"
 echo ""
else
 echo "The scanned label has an incorrect format: $label"
 echo "The correct format should be: 650-00953-## ##NR######### ##:##:##:##:##:##"
fi

