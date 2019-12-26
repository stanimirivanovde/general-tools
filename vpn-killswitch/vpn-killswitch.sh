# This script creates a pf.conf killswitch rules if they don't exist and enables
# the packet filtering.

ENABLE=0
TEST=0
for i in "$@"; do
	case $i in
		-e*|--enable*)
		ENABLE=1
		shift # past argument=value
		;;
		-t*|--test*)
		TEST=1
		shift # past argument=value
		;;
		*)
			  # unknown option
		;;
	esac
done
echo "ENABLE  = ${ENABLE}"
echo "TEST    = ${TEST}"
echo

if [ "${ENABLE}" -eq 1 ]; then
	# Disable the packet filtering if enabled
	sudo pfctl -d

	# Load the rules
	sudo pfctl -f ~/openvpn/killswitch.v2.pf.conf

	# Enable the firewall
	sudo pfctl -e

	# De-activate with sudo pfctl -d
	echo "Kill switch activated."
	exit 0
fi

if [[ "${TEST}" -eq 1 ]]; then
	# Make sure this is routed correctly
	echo ""
	echo "Pinging..."
	ping -c 2 1.1.1.1
	sleep 1s
	ping -c 2 8.8.8.8

	echo ""
	echo "Tracing..."
	traceroute -m 4 google.com
	sleep 1s
	traceroute -m 4 yahoo.com
	sleep 1s

	echo ""

	echo "DNS stats:"
	echo 'iPhone: ' $(networksetup -getdnsservers 'iPhone USB')
	echo 'Wi-Fi: ' $(networksetup -getdnsservers 'Wi-Fi')
	nslookup google.com
	exit 0
fi

echo "!!! Unknown parameter specified."
echo "Usage:"
echo "$0 --enable      : Enables the kill switch."
echo "$0 --test        : Runs tests."


