# show-my-connections.sh
This tool will list all remote established TCP connections on your computer. By default it lists the application that is having the connection using the 'lsof' command. If further investigation is needed you can use the '-r' argument to do a WHOIS resolution of the IP addresses. This way you can inspect them and see if there is anything suspicious.

## *Usage*
    -h [ -? ]                This help Message
    -r                       Does a WHOIS lookup on the remote IP addresses.
