#!/bin/env perl

# Bright setup script (1 of 2) to populate mac address into bright using cmsh 
# source is from rocks list hosts
# output is a file that is easy to parse into cmsh commands
# part 2 is call the addNodeToBright.plx script (which take this input, and need updating)
# -Tin 2014.10.16
#
# run as ./macs4cmsh.plx > walk-nodes.csv
# For RHEL7 machines, where NIC are eno1/eno2 instead of eth0/eth1, instead run as:
# run as ./macs4cmsh.plx | sed 's/eth1/eno2/' > bb8-nodes.csv
#
# 

# sample input:
# obi/bak2014_0910]$ less rocks_list_host_if.txt
# HOST            SUBNET     IFACE MAC               IP            NETMASK       MODULE NAME           VLAN OPTIONS CHANNEL
# walk-4-1:  public     eth0  00:1b:21:d7:09:f0 10.100.8.69   255.255.255.0 ------ walk-4-1  ---- ------- -------
# walk-4-1:  ---------- eth1  00:1b:21:d7:09:f1 ------------- ------------- ------ --------- ---- ------- -------
# walk-4-1:  private    eth2  78:2b:cb:50:39:6b 192.168.2.175 255.255.255.0 ------ walk-4-1  ---- ------- -------
# walk-4-1:  ---------- eth3  78:2b:cb:50:39:6d ------------- ------------- ------ --------- ---- ------- -------
# walk-4-1:  ---------- eth4  78:2b:cb:50:39:6f ------------- ------------- ------ --------- ---- ------- -------
# walk-4-1:  ---------- eth5  78:2b:cb:50:39:71 ------------- ------------- ------ --------- ---- ------- -------

# sample output:
# r2d2:/root/script/walk-nodes.csv
# # nodename,mac,external-if,external-ip,ipmi-ip
#walk-4-1,78:2b:cb:50:39:6b,eth0,10.100.8.69,10.100.58.119
#walk-4-4,bc:30:5b:f3:b5:04,eth3,10.100.8.72,0.0.0.0


use strict;
use Socket;

# file below is a cache of "rocks host list" 
my $nodesfile = "./rocks_list_host_if.bb8.txt";
## these are output fields:
my ($name, $intMac, $extIface, $extIp, $ipmiIp);

## the biggest trick is needing priv interface mac but ip of public interface

$name = "";
$intMac = "";       #priv-mac, mac for boot interface
$extIface = "";
$extIp = "";
$ipmiIp = "";
#my $extIpPrefix = "";  
#my $extIpLastOctet = "";
#my $ipmiIpPrefix = "";
#my $extNetPrefix = "10.100.8.";

# thse are parsing each input line
my ($host,$subnet,$iface,$mac,$ip,$netMask,$module,$hostname,$vlan,$opt,$channel);


# print header line to output
print( "# nodename,internal-mac,external-if,external-ip,ipmi-ip\n" );

open(NODESFILE, "<", $nodesfile) || die "could not open nodesfile\n";
while(<NODESFILE>) {
        my $inputLine = $_;
        chomp $inputLine;
        # HOST       SUBNET     IFACE MAC               IP            NETMASK       MODULE   NAME    VLAN OPTIONS CHANNEL
        # walk-4-1:  private    eth2  78:2b:cb:50:39:6b 192.168.2.175 255.255.255.0 ------ walk-4-1  ---- ------- -------
        # walk-4-1:  ---------- eth3  78:2b:cb:50:39:6d ------------- ------------- ------ --------- ---- ------- -------
        #    $1       $2         $3    $4                $5            $6                   $7     
        # ([\w\d-]+)   :  ([\w\d-]+)  
        #if( $inputLine =~ /([\w\.]+)\s+([\d]+\s+[\d]+\s+[\d]+\s+[\w_]+)\s+([\w_\.]+)\s+([A-Za-z]\d+[A-Za-z])\s+([NX]P_[\d\.]+)/ ) {           ## include NP_ in gi
        #if( $inputLine =~ /([\w\d-]+) / ) {
        
        next if( $inputLine =~ /^#/ );
        ($host,$subnet,$iface,$mac,$ip,$netMask,$module,$hostname,$vlan,$opt,$channel) = split( /[\s]+/, $inputLine );
        next if( $subnet =~ /--[-]*/ );
        #print( "##src##",$host,$subnet,$iface,$mac,$ip,$netMask,$module,$hostname,$vlan,$opt,$channel);
        #print( "\n" );
        #print( "    ##TMP##", $host, $mac, $subnet, "\n"); ##, $net, $ip

        # file parsing logic:
        # (the biggest trick is needing priv interface mac but ip of public interface)
        # set node name when see private as subnet and have mac
        # set ip when see public and have basis for IP.
        # print output when all data is present
        # (reset data after print)

        if( $subnet =~ /private/ ) {
            if( $host =~ /([\w-]+):/ ) {
                $name = $1;
            }elsif( $host =~ /([\w-]+)/ ) {     # in case ther eis no : 
                $name = $1;
            }else{
                print( "SKIPPING $host, unhandled name format...\n" );
            }
            ## ++ parse hostname, strip : out of it.
            # ip parsing works below, but not needed.
            #if( $ip =~ /([\d]+)\.([\d]+)\.([\d]+)\.([\d]+)/ ) {
                #$extIpPrefix = $1 . "." . $2 . "." . $3 . "." ;
                #$extIpLastOctet = $4;
            #}else{
                #print( "#Line skipped, unable to parse: $inputLine\n" );
            #}
            $intMac = $mac;
        } elsif( $subnet =~ /public/ ) {
            $extIface = $iface;
            $extIp = $ip;
        } else {;
            next;
        }

        # prepare to write output.
        # fields needed in output: ($name, $mac, $extIface, $extIp, $ipmiIp);
        if( $name ne "" && $extIface ne "" ) {
            ## determine $ipmiIp by dns lookup of hostname-ctl
            my( $ctlName );
            $ctlName = $name . "-ctl";
            my @addressList = gethostbyname($ctlName);
            if( scalar( @addressList ) == 0 ) {
                $ipmiIp = "0.0.0.0";
            } else {
                $ipmiIp = inet_ntoa($addressList[4]);
                # http://bioinfo2.ugr.es/documentation/Perl_Cookbook/ch18_02.htm
            } 
            
            print( "$name,$intMac,$extIface,$extIp,$ipmiIp\n" ); ##, $extIp, $ipmiIp
            # reset everything and move on to the next line (hopefully new host)
            $name = "";
            $intMac = "";
            $extIface = "";
            $extIp = "";
            $ipmiIp = "";
            #$extIpPrefix = ""; 
            #$extIpOctet = "";
            #$ipmiIpPrefix = "";
            next;
        } 
        #} else {
        #       print( "#Line skipped, unable to parse: $inputLine\n" );
        #}
        # no error handling.  potentially input file could have either only public or private ip
        #  and host will be dropped by this script

}
