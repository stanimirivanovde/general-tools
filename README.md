# general-tools
This is a repository that contains different tools I wrote through the years. Feel free to use them as you please.

## show-my-connections (Mac OS X / FreeBSD)
This is a tool to list the current established connections your computer has to a remote host. It is useful to see if you have suspicious connections going and to investigate them further. The tool can do a WHOIS lookup on the connections.

## check-public-ip (FreeBSD / FreeNAS)
Checks the public IP of your computer/server and sends you an e-mail if it has changed. You'll need to have ssmtp installed and configured correctly. A sample ssmtp.conf file is included for Yahoo e-mails.

## brew-upgrade (Mac OS X)
Upgrades all brew packages including the casks and cleans up afterwards.

## local-dns (Mac OS X)
Tools to list and set local DNS server on Mac OS X. This is useful if you want to run your own stubby or dnscrypt-proxy servers on the localhost to enable DNS over HTTPS OR TLS (DOH, DOT).

## vpn-killswitch (Mac OS X)
Configures a VPN killswitch that only allows traffic to a single IP address (the VPN IP address).

## docker-tools
Various docker tools to help with administrating docker containers
