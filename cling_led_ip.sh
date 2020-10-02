#!/bin/bash
#this scritp disables the standart LED trigger of a raspberry pi  for the green light. It reads tue current Ip runs through its every figure and makes the LED blink 
#accordingly. The number of short blinks is a figure of the ip adress. The first long blink is to inform the user that the script is running.

#checking if user has root priveleges

#echo
#echo 'Attention, this script will modify these files on your Raspbery : /sys/class/leds/led0/trigger  and  /sys/class/leds/led0/brightness'
#echo


#This script needs to be run under root or with sudo, so we are checking the user id first"

if [[ "${UID}" -ne "0" ]]
then
	echo 'Please run this script with "sudo" or as root' >&2
	exit 1
fi

#In order to take control over the LED of your raspberry it is necessary to disable standart led mode 

sh -c "echo none > /sys/class/leds/led0/trigger"

#setting the duration of cling
SIGNAL_LENGHT=2

cling() {

sh -c "echo 0 > /sys/class/leds/led0/brightness"
sleep "${SIGNAL_LENGHT}"
sh -c "echo 1 > /sys/class/leds/led0/brightness"
sleep "${SIGNAL_LENGHT}"
sh -c "echo 0 > /sys/class/leds/led0/brightness"

}

#number of clings depending on the 1st parameter

multiple_clings() {
for i in $(seq 1 ${1})
do
cling
done
}


#notifying user about running
multiple_clings "1"

#checking ip and formate it in an array of separate characters
IPLINE=$(hostname -I | cut -f 1 -d " " | fold -w1)

#running cling function for ip adress 
for element in ${IPLINE}
	do
		if [[ "${element}" = '.'  ]]
			then
		  		 SIGNAL_LENGHT=1
				 cling
		else
	        		sleep 0.4
				SIGNAL_LENGHT=0.1
      	 			multiple_clings "${element}"
		fi

echo "${element}"
done
