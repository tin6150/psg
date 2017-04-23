#!/bin/env perl 

use strict;

# Bright setup script 2 of 2.
# take input file with list of node info (mac, ip, etc) and 
# create a series of cmsh commands to pre-create the compute node object in bright.
# -Tin 2014.10.16

# sample run: 
# ./addNodeToBright.plx > cmd4bright.cmsh
# review output to ensure all is good, enable commit, then run file as
# cmsh -f cmd4bright.cmsh

## when running cmsh, ignore message that says:
## Base name mismatch, IP settings will not be modified!
## when cloning a node, it does not cloen the IP address, which make sense.  message is about that.



##my ($name, $intMac);
#my $nodesfile = "walk-nodes.csv";                  # generated from output of macs4cmsh.plx
#my $nodesfile = "walk-nodes.new6.csv";             # generated from output of macs4cmsh.plx
#my $nodesfile = "walk4s-nodes.csv";                # final migration wave.  2016.0526
#my $template  = "walk-4-1";                         # 4-4 and 4-5 use eth2 as bootif, eth3 as public.  no other node boot off eth3
my $nodesfile = "bb8-nodes.csv";                    # bb8 2017
my $template  = "skywalker-3-9";                    # 

# input file new req:
# nodename,internal-mac,external-if,external-ip,ipmi-ip

print "device\n";
###my $intNetPrefix = "10.100.38.";
###my $ibNetPrefix  = "10.100.39.";
my $intNetPrefix = "192.168.3.";
my $ibNetPrefix  = "192.168.6.";

open(NODESFILE, $nodesfile) || die "could not open nodesfile\n";
while(<NODESFILE>) {
    chomp;
    next if( /^#/ );
    my ($name, $intMac, $externalIf, $extIp, $ipmiIp)  =  split(/,/,$_);
    #my $tempip = $privnetip =~ ([0-9]*.);
    # private ip will be constructed from ext-ip, using same last octet

    my ($intIp, $ibIp) = ("0.0.0.0", "0.0.0.0");
        # need to generate internal IP and infiniband IP based on the external IP of the node
        my $lastOctet;
        if( $extIp =~ /([\d]+)\.([\d]+)\.([\d]+)\.([\d]+)/ ) {
                #$extIpPrefix = $1 . "." . $2 . "." . $3 . "." ;
                $lastOctet = $4;
                $intIp = $intNetPrefix . $lastOctet;
                $ibIp  = $ibNetPrefix  . $lastOctet;
        } else {
                print( "  ** WARNING ** unparsable IP $extIp \n " );
        }


    if ($name ne $template) {
        print "clone $template $name\n";
    } else {
        print "use $template\n";
    }
    print "set mac $intMac\n";
    #print "set category hadoop\n";    # no need to set as template already this category
    print "interfaces\n";
    #- ipmi not configured in new bright setup for bb8 
    #- print "use ipmi0\n";
    #- print "set ip $ipmiIp\n";
    #- print "exit\n";
    print "use bootif\n";
    print "set ip $intIp\n";
    print "exit\n";
        #if( $externalIf eq "eth1" ) {
        if( $externalIf eq "eno2" ) {
                print "use $externalIf\n";
        } else {
                # the base node for clone has eth1 for external interface.  change it if it is not using eth1 on this node.
                print "remove eno2\n";
                print "add physical $externalIf\n";
                print "set network externalnet\n";
        }
    print "set ip $extIp\n";
    print "exit\n";
    print "use ib0\n";
    print "set ip $ibIp\n";
    print "exit\n";
    print "exit\n";    # take us back to interfaces mode
    print "exit\n";    # take us back to device mode
    print "\n";
}
close(NODESFILE);

print "##commit\n";             # if truly wants to commit, take out the # signs

