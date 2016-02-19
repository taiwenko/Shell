#!/bin/sh
COUNTER=0

if [ -n "$2" ]
then
    COUNTER=$(($1-1))
	while [  $COUNTER -lt $2 ]; do
        COUNTER=$(( $COUNTER + 1))
        echo 'Setting up 192.168.0.'$COUNTER
        sh doitDVT3.sh 192.168.0.$COUNTER
    done
else
    echo 'Please enter starting and ending IP addresses'
fi
