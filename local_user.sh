#!/bin/bash
#This script creates a user on la local system.
#you must supply a username as an argument to the script
#Optionnally, you can also provide a commetn for account as an argument
#A Password will be automaticly generated for the account
#The username, password ant host for the account will be displayed

#Make sure it is being run under root or with sude priveledges

if [[ "${UID}" -ne 0 ]]
then
	echo 'Please run this scrit with sudo or as root'
	exit 1
fi


#if they don't suppy atleast one argument the scripts ends with 1 status and shows a message informing of the scrip usage

if [[ "${#}" -lt 1  ]]
then
	echo "Required usage is ${0}, USER_NAME [COMMENT]..."
	echo "Create an account on the local system with the name of USER_NAME and a comments field of COMMENT"
	exit 1
fi


# the first parameter is the user name

USER_NAME="${1}"

#The rest of the parameters are fot the account comments.

shift
COMMENT="${@}"

#generate a password

PASSWORD=$(date +%s%N | sha256sum | head -c48)

#Create the account

useradd -c "${COMMENT}" -m ${USER_NAME} -s /bin/bash

#check if the account is created

if [[ "${?}" -ne 0 ]]
then
	echo "The user account could not be created"
	exit 1
fi


#set the password

echo "$USER_NAME:$PASSWORD" |  chpasswd

#check to see is tha chpasswd command succeded

if [[ "${?}" -ne 0 ]]
then
	echo "The password could not be set"
	exit 1
fi

# Force passord change

passwd -e ${USER_NAME}

#Display the information 

echo
echo "You have created an account with username :"
echo "${USER_NAME}"
echo
echo "Password :"
echo "${PASSWORD}"
echo
echo "Host :"
echo "${HOSTNAME}"
echo 
exit 0

