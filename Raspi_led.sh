#!/bin/bash
#this scritp turns on(value1) or turns off(0) the led

#checking if user has root priveleges

echo
echo 'Attention, this script will modify these files on your Raspbery : /sys/class/leds/led0/trigger  and  /sys/class/leds/led0/brightness'
echo


#This script needs to be run under root or with sudo, so we are checking the user id first"

if [[ "${UID}" -ne "0" ]]
then
	echo 'Please run this script with "sudo" or as root' >&2
	exit 1
fi

#In order to take control over the LED of your raspberry it is necessary to disable standart led mode 

sh -c "echo none > /sys/class/leds/led0/trigger"

#let the user chose either switch on or off the led
echo "Please chose if you want to switch on/off your Raspberry green led: "
read STATUS

if [[ "${STATUS}" = 'on' ]]
	then
		echo 'Switching green led on'
		VALUE=1
elif [[ "${STATUS}" = 'off' ]]
	then
		echo 'Switching green led off'
		VALUE=0
else
	echo 'Invalid option. only "on" or "off" is supported. Please retry' >&2
exit 1
fi

#changing the dedicated file
sh -c "echo ${VALUE} > /sys/class/leds/led0/brightness"
