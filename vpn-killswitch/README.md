## vpn-killswitch (Mac OS X)
Configures a VPN killswitch that only allows traffic to a single IP address (the VPN IP address). It uses pfctl to enable and disable the packet filtering rules. Edit the included **killswtich.v2.pf.conf** file and fill in your network and VPN details.

## *Usage*
    -t [--test]     Tests a kill switch by doing a couple of traceroutes and pings. Make sure the traffic is now routed through your VPN IP address.
    -e [--enable]   Enable the VPN killswitch. If the VPN is down all traffic will be stopped. If the VPN is up all traffic will be routed through its IP

You can test if this works if you are able to run the tests with the VPN up but the tests should fail when the VPN is down. In order to disable the firewall and restore connectivity when the VPN is down do:

    sudo pfctl -d

