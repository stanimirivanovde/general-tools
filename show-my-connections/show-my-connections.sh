#!/bin/bash

function show_help {
	echo "Options: "
	echo "          -h (?)     This help message"
	echo "          -r         Resolve all IP addresses that you have an established connection with using WHOIS"
}

# Reset in case getopts has been used previously in the shell.
OPTIND=1

# Are we resolving names using WHOIS or not?
resolveNames=0

while getopts "h?r" opt; do
	case "$opt" in
		h|\?)
			show_help
			exit 0
			;;
		r)  resolveNames=1
			;;
	esac
done

if [ $resolveNames -eq 0 ]
then
	# Print all applications' connections that are established
	lsof -i | grep EST | grep -v localhost
	exit 0
fi

# Make the delimiter a new line so we can parse correctly our strings
copyIFS=$IFS
IFS=$'\n'

# Get a list of connections using netstat. This only lists the tcp connections. It removes all
# connections from localhost to localhost. It lists only the established connections.
listOfConnections=`netstat -nap tcp | grep EST | grep -v "127.0.0.1" | cut -d' ' -f 21`

echo "The list of connections:"
echo "${listOfConnections}"
echo "--------------"

# Revert back our delimiter so we can correctly parse our arrays
IFS=$copyIFS

# We need to extract from the connections the IP addresses of the remote end and try to WHOIS it.
for i in $listOfConnections
do
	# Currently we have a string that looks like this: 72.21.91.121.https
	# This represents the IP address and the port for the remote connection.
	# We need to remove the last .https. The way I am going to do this is to
	# split this string to an array on the '.' character and then just skip the last
	# part of the array. Then I'll reconstitute the array with the '.' character. Easy?

	# Split our entry into an array
	ipArray=(${i//./ });

	# Loop through the array and collect all parts but the last one
	# How many elements we have processed
	count=0
	arraySize=${#ipArray[@]}
	(( --arraySize ))
	while [ $count -lt $arraySize ]
	do
		element=${ipArray[${count}]}
		# Concatenate the elements with "."
		if [ $count -eq 0 ]
		then
			# If we are at the first element then don't concatenate. Instead just use the first element.
			ipAddress="${element}";
		else
			# If we are not on the first element then just concatenate
			ipAddress="${ipAddress}.${element}";
		fi
		# Increment count
		(( ++count ))
	done
	echo "Quering WHOIS for the IP Address: $ipAddress"
	whois $ipAddress
done
