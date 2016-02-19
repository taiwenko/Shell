#!/bin/bash

ton=`date +%s`
echo "Timestamp $ton"
while [ 1 ]; do
   for i `seq 1 50`; do
       ping -c 1 alt$i
       if [ $? == 1 ]; then
           echo "`date`: alt$i failed to reply"
           ton=`date +%s`
       fi
   done
   tnow=`date +%s`
   
