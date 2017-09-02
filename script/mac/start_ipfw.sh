#!/bin/sh
# Startup script for ipfw on Mac OS X
# ref: http://blog.scottlowe.org/2012/04/05/setting-up-ipfw-on-mac-os-x/

# Flush existing rules
/sbin/ipfw -f -q flush

# Silently drop unsolicited connections
/usr/sbin/sysctl -w net.inet.tcp.blackhole=2
/usr/sbin/sysctl -w net.inet.udp.blackhole=1

# Load the firewall ruleset
/sbin/ipfw -q /etc/ipfw.conf

## *sigh*   don't seems like ipfw cmd is avail in 10.12... 
## may still be installable... but more headache than I was hoping fore
## ref: http://www.novajo.ca/firewall.html
