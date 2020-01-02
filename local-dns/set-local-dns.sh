#!/bin/bash

# This script will list all of the configured DNS servers on Mac OS X

IFS=$'\n';
# Remove the first line which is informational only: An asterisk (*) denotes that a network service is disabled.
for i in $( networksetup -listallnetworkservices | grep -v "An asterisk"); do
	echo "Setting local DNS to $i"
	sudo networksetup -setdnsservers "$i" 127.0.0.1
done
