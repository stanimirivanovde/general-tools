# general-tools
This is a repository that contains different tools I wrote through the years. Feel free to use them as you please.

## show-my-connections (Mac OS X / FreeBSD)
This is a tool to list the current established connections your computer has to a remote host. It is useful to see if you have suspicious connections going and to investigate them further. The tool can do a WHOIS lookup on the connections.

## check-public-ip (FreeBSD / FreeNAS)
Checks the public IP of your computer/server and sends you an e-mail if it has changed. You'll need to have ssmtp installed and configured correctly. A sample ssmtp.conf file is included for Yahoo e-mails.

## brew-upgrade (Mac OS X)
Upgrades all brew packages including the casks and cleans up afterwards.

## list-dns (Mac OS X)
Lists all configured DNS servers on each network connection. This is useful when using something like dnscrypt-proxy or stubby to make sure that your local DNS is set to localhost on all of your connections.
