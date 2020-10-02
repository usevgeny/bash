#!/bin/bash

#this script generates a password
#this user can set the password length with -l and add a special caracter ith -s
#verbose mod can be enabled with -v

usage() {
	echo "Usage: ${0} [-vs] [-l LENGHT]" >&2
	echo 'Generate a random password.'
	echo ' -l LENGHT Specify the password length'
	echo ' -s        Append a special caracter to the password.'
	echo ' -v        Increase verbosity.'
	exit 1
}

log() {
local MESSAGE="${@}"
if [[ "${VERBOSE}" = 'true' ]]
then
	echo "${MESSAGE}"
fi

}

#set a default password  length
LENGTH=48

while  getopts vl:s OPTION
do
case ${OPTION} in
	v)
	 VERBOSE='true'
        log 'Verbose mode on.'

	;;

	l)
	 LENGTH="${OPTARG}"
	;;
 	s)
	 USE_SPECIAL_CARACTER='true'
	;;
   	?)
	 usage
	;;
esac
done

#echo "Nulber of args: ${#}"
#echo "All args: ${@}"
#echo "First arg : ${1}"
#echo "Secont arg : ${2}"
#echo "Third arg : ${3}"
# Inspect OPTIND

#echo "OPTIND: ${OPTIND}"

# Remove the options while leaving the remaining arguments
shift "$(( OPTIND -1  ))"

#echo 'After the shift:'
#echo "Nulber of args: ${#}"
#echo "All args: ${@}"
#echo "First arg : ${1}"
#echo "Secont arg : ${2}"
#echo "Third arg : ${3}"

if [[ "${#}" -gt 0 ]]
then
	usage
fi




log 'Generating a pasword.'

PASSWORD="$(date +%s%N | sha256sum | head -c${LENGTH})"

#append a special caracter if requested to do so 

if [[ "${USE_SPECIAL_CARACTER}" = 'true'  ]]
then
log 'Selecting a random special caracter'
SPECIAL_CARACTER=$(echo '()!&@#$€-_+=%`£^¨?;.:/÷' | fold -w1 | shuf | head -c1)
PASSWORD="${PASSWORD}${SPECIAL_CARACTER}"
fi
log  'Done.'
log 'Here is the password: '

#DISPLAY THE PASSWORD

echo "${PASSWORD}"

exit 0
