#!/usr/local/bin/bash

# This is a FreeBSD script to check if your IP has changed and send you an e-mail if so.
# It needs ssmtp to be configured correctly to send the mail.

function getIp {
	dig +short myip.opendns.com @resolver1.opendns.com
}

function sendMail {
	message="$1"
	printf "Sending the following message:\nFrom: example@yahoo.com\nTo: example@yahoo.com\nSubject: IP Address Change\n\n${message}"
	printf "From: example@yahoo.com\nTo: example@yahoo.com\nSubject: IP Address Change\n\n$message" | /usr/local/sbin/ssmtp example@yahoo.com
}

# The file that stores our last valid public IP address
ipAddressFile="/root/currentIp.txt"

date

publicIp=$( getIp )

echo "The public IP: ${publicIp}"

if [ -z "$publicIp" ]
then
	echo "Can't retrieve the public IP."
	exit 1
fi

# If the file doesn't exist then create it
if [ ! -f "$ipAddressFile" ]
then
	echo "Creating the IP storage file $ipAddressFile"
	echo $publicIp > $ipAddressFile
	exit 0
fi

# Read the currently saved IP
currentIp=$( cat $ipAddressFile )

echo "The current IP: ${currentIp}"

# If the current IP is NULL for some reason
if [ -z "$currentIp" ]
then
	echo $publicIp > $ipAddressFile
	exit 0
fi

if [ "$publicIp" != "$currentIp" ]
then
	# Send e-mail
	message="The IP has changed from $currentIp to $publicIp. Sending mail."
	echo $message
	sendMail "$message"
	echo $publicIp > $ipAddressFile
fi

