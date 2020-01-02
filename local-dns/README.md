## list-dns (Mac OS X)
Lists all configured DNS servers on each network adapter. This is useful when using something like dnscrypt-proxy or stubby to make sure that your local DNS is set to localhost on all of your network adapters.

## set-local-dns (Mac OS X)
Sets the DNS server for all network adapters to 127.0.0.1. This is useful if you're running dnscrypt-proxy or stubby so that every network adapter on your computer will use that DNS server.

## dnscrypt-proxy.toml (Cross Platform)
This is my secure dnscrypt-proxy.toml configure file. It only uses the most secure DNS servers that don't do logging and support DNSCrypt.

## stubby.yml (Cross Platform)
This is my stubby configuration file to use DLS-over-TLS with the Cloud Flare DNS service 1.1.1.1 and 1.0.0.1.
