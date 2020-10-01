#!/bin/bash
#This scrip provides changes in system files. Written for personnal uses on CenTOS
#It modyfyes network settings depending on user input


#checking if user has root priveleges

if [[ "${UID}" -ne "0" ]]
then
	echo 'Please run this script with "sudo" or as root' >&2
	exit 1
fi
# if verbosity is chosen, than it shows all the process, and leaves a trace in logfile 


log () { 

	if [[  "${VERBOSITY}" = 'true' ]]
		then 
			echo "${MESSAGE}"
	fi

	logger -t iphone_switch "${MESSAGE}"

}

#before we create a substitution to an existing file,it it necessary to backup existing ones
backup_network() {
	local NETWORK_FILE="$(/etc/sysconfig/network)"
	if [[ -f "${NETWORK_FILE}" ]]
	then
		local BACKUP_NETWORK="/var/tmp/$(basename ${NETWORK_FILE}).$(date +%F-%N)"
		log "Backing up ${NETWORK_FILE} to ${BACKUP_FILE}."
		#the exit status of the functioin wille be the exit status of the cp command
		cp -p ${NETWORK_FILE} ${BACKUP_NETWORK}
	else
		#the file does not exist. Exit with no zero status
		return 1
	fi

}


backup_network_scripts() {

	local NETWORK_SCRIPTS="$/etc/sysconfig/network-scripts"
	if [[ -f "${NETWORK_SCRIPTS}" ]]
	then
		local NETWORK_SCRIPTS_BACKUP="/var/tmp/$(basename ${NETWORK_SCRIPTS}).$(date +%F-%N)"
		log "Backing up ${NETWORK_SCRIPTS} to ${NETWORK_SCRIPTS_BACKUP}."
		#the exit status of the functioin wille be the exit status of the cp command
		cp -r -p ${NETWORK_SCRIPTS} ${NETWORK_SCRIPTS_BACKUP}

	else
		#the dir doesnot exist. Exit with no zero status
		return 1

		
	fi

}

report() {
	#make a decisoin based  on the exit status of the function
	if [[ "${?}" -eq '0' ]]
		then
			log 'Success!'
			else
				log 'Fail.'
			exit 1
		fi
	}



changing_network() {
#applying changes for the gateway
echo 'NETWORKING=yes' > /etc/sysconfig/network
echo "GATEWAY=${NEW_GATEWAY}" >> /etc/sysconfig/network
}


changing_nsfn() {

#Applying changes for the network-scripts

#the name of the nteworkscript could be different so it will be applied accordingly. head -n1 is to chose the first file in the list

NETWORK_SCRIPT_FNAME="$(ls /etc/sysconfig/network-scripts | head -n1)"

echo 'TYPE=Ethernet' >> /etc/sysconfig/network-scripts/$(basename ${NETWORK_SCRIPT_FNAME})
echo 'PROXY_METHOD=none' >> /etc/sysconfig/network-scripts/$(basename ${NETWORK_SCRIPT_FNAME})
echo 'BROWSER_ONLY=no' >> /etc/sysconfig/network-scripts/$(basename ${NETWORK_SCRIPT_FNAME})
echo 'BOOTPROTO=none' >> /etc/sysconfig/network-scripts/$(basename ${NETWORK_SCRIPT_FNAME})
echo 'DEFROUTE=yes' >> /etc/sysconfig/network-scripts/$(basename ${NETWORK_SCRIPT_FNAME})
echo 'IPV4_FAILURE_FATAL=no' >> /etc/sysconfig/network-scripts/$(basename ${NETWORK_SCRIPT_FNAME})
echo "IPADDR=172.20.10.2" >> /etc/sysconfig/network-scripts/$(basename ${NETWORK_SCRIPT_FNAME})
echo 'NETMASK=255.255.255.0' >> /etc/sysconfig/network-scripts/$(basename ${NETWORK_SCRIPT_FNAME})
echo 'IPV6INIT=no' >> /etc/sysconfig/network-scripts/$(basename ${NETWORK_SCRIPT_FNAME})
echo '#IPV6_AUTOCONF=yes' >> /etc/sysconfig/network-scripts/$(basename ${NETWORK_SCRIPT_FNAME})
echo '#IPV6_DEFROUTE=yes' >> /etc/sysconfig/network-scripts/$(basename ${NETWORK_SCRIPT_FNAME})
echo '#IPV6_FAILURE_FATAL=no' >> /etc/sysconfig/network-scripts/$(basename ${NETWORK_SCRIPT_FNAME})
echo '#IPV6_ADDR_GEN_MODE=stable-privacy' >> /etc/sysconfig/network-scripts/$(basename ${NETWORK_SCRIPT_FNAME})
echo 'NAME=enp0s3' >> /etc/sysconfig/network-scripts/$(basename ${NETWORK_SCRIPT_FNAME})
echo 'UUID=141a5b86-f665-4bbc-8678-d96b6df0cc98' >> /etc/sysconfig/network-scripts/$(basename ${NETWORK_SCRIPT_FNAME})
echo 'DEVICE=enp0s3' >> /etc/sysconfig/network-scripts/$(basename ${NETWORK_SCRIPT_FNAME})
echo 'ONBOOT=yes' >> /etc/sysconfig/network-scripts/$(basename ${NETWORK_SCRIPT_FNAME})

}

while  getopts vl:s OPTION
do
	case ${OPTION} in
		v)
		VERBOSE='true'
        log 'Verbose mode on.'
		;;
esac
done


log 'backing up network file '
backup_network
report

log 'backing up network scripts '
backup_network_scripts
report


#let user enter new fixed  ip

echo 'Please enter your new fixed IP XX.XX.XX.XX : '
read NEW_FIXED_IP
echo "${NEW_FIXED_IP}"
log 'New fixed IP is : ${@} '

#let user enter new GATEWAY

echo 'Please enter your new GATEWAY XX.XX.XX.XX : '
read NEW_GATEWAY
log 'New GATEWAY is : ${@} '


echo 'Applying changes...'
log 'changing network file '
changing_network
report

log 'changing network scripts '
changing_network
report

#showing user new network settings

echo "here are new network settings:"
echo "network file:"
echo "$(cat /etc/sysconfig/network)"
echo
echo "network-script :"
echo "$(cat /etc/sysconfig/network-scripts/$(basename ${NETWORK_SCRIPT_FNAME}))"

echo 'please reboot to apply all the changes'

