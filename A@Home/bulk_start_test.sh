#!/bin/sh
COUNTER=0


if [ -n "$2" ]
then
    COUNTER=$(($2-1))
fi

if [ -n "$1" ]
then
	while [  $COUNTER -lt $1 ]; do
        COUNTER=$(( $COUNTER + 1))
        echo 'Starting DEVICE' $COUNTER
        sh start_test.sh alt$COUNTER
        sleep 1
    done
else
    echo 'Please add number of devices to start'
fi
