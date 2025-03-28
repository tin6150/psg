#!/bin/perl 
# 5.26.3 mster.s4
# run as:  perl  sshExpectRacAdm.pl
# not needed to run as this: perl -I /global/home/users/tin/perl5/lib sshExpectRacAdm.pl
# worked for half1 of savio4  to disable NIC from OS.   2025.03.17
# need to set ipmiPassword
#  needed CPAN install Bundle::Expect as tin  (didnt end up using OS expect pkg)

#xx use lib "/global/home/users/tin/perl5/lib"

## #!/usr/prog/perl/5.10.1/bin/perl

## #!/usr/bin/perl


use Expect;
use warnings;
use strict;
#xx use feature "state"

print "Expect module available... Good, spawning ssh sessions now...\n";

##my $command = "/bin/hostname";
my $command = "ssh ipmi-n0069.savio4";
#my @params = ("localhost");
my $perltidx;
my $sshkey_timeout = 4;
my $timeout = 30;
#my @match_patterns = ">";
my $cmdAtHost = "uptime";

my @hostlist;
#push( @hostlist, "linux-tin2" );
#push( @hostlist, "usvm-bofh1" );
#my @hostlist = ("linux-tin2", "usvm-bofh1" );
my @esx_hostlist = ("usesx10sc" );
#my @racadm_hostlist = ( "ipmi-n0069.savio4" );
#my @racadm_hostlist = ( "ipmi-n0009.savio4" );
#my @racadm_hostlist = ( "ipmi-n0010.savio4", "ipmi-n0011.savio4" );
#++#"ipmi-n0070.savio4" );

#my @racadm_hostlist = ( "ipmi-n0012.savio4", "ipmi-n0013.savio4", "ipmi-n0014.savio4", "ipmi-n0015.savio4", "ipmi-n0016.savio4", "ipmi-n0017.savio4", "ipmi-n0018.savio4", "ipmi-n0019.savio4" );

#my @racadm_hostlist = ( "ipmi-n0040.savio4", "ipmi-n0041.savio4", "ipmi-n0042.savio4", "ipmi-n0043.savio4", "ipmi-n0044.savio4", "ipmi-n0045.savio4", "ipmi-n0046.savio4", "ipmi-n0047.savio4", "ipmi-n0048.savio4", "ipmi-n0049.savio4", "ipmi-n0050.savio4", "ipmi-n0051.savio4", "ipmi-n0052.savio4", "ipmi-n0053.savio4", "ipmi-n0054.savio4", "ipmi-n0055.savio4", "ipmi-n0056.savio4", "ipmi-n0057.savio4", "ipmi-n0058.savio4", "ipmi-n0059.savio4" );

my @racadm_hostlist = ( "ipmi-n0072.savio4", "ipmi-n0073.savio4", "ipmi-n0074.savio4", "ipmi-n0075.savio4", "ipmi-n0076.savio4", "ipmi-n0077.savio4", "ipmi-n0078.savio4", "ipmi-n0079.savio4", "ipmi-n0080.savio4", "ipmi-n0081.savio4", "ipmi-n0082.savio4", "ipmi-n0083.savio4"  );

## OJO: add ; at end of perl line!
##  for N in $(seq -w 12 1 19); do echo "\"ipmi-n00$N.savio4\","; done
##  for N in $(seq -w 40 1 59); do echo "\"ipmi-n00$N.savio4\","; done
##done my @racadm_hostlist = ( "ipmi-n0068.savio4" );
##done my 
#my @racadm_hostlist = ( "ipmi-n0070.savio4" );
##  for N in $(seq -w 72 1 83); do echo "\"ipmi-n00$N.savio4\","; done

#@hostlist = @esx_hostlist;
@hostlist = @racadm_hostlist;


print "hostlist is @hostlist\n" ;

#my $id ;
#for( $id=13; $id<=16; $id++ ) {
	#print "working on...  mvusca${id}sc\n"
#}

my $host;
foreach $host ( @hostlist ) {
#  for( $id=13; $id<=14; $id++ ) 
	## $host = "vmusca" . $id . "sc";
	print( "\n\n     ===== Now working on $host =====  \n\n" );

	my $exp = new Expect;
	#$exp->debug(3);
	#$exp->exp_internal(1);
	$exp->log_file("sshExpect.log");

	$exp->raw_pty(1);
	##$exp->spawn( $comand, @params) or die "Cannot spawn $command: $!\n";
	$command = "ssh -l root $host";
	$exp->spawn( $command ) or die "Cannot spawn $command: $!\n";
	##$exp->spawn( "ssh localhost" ) or die "Cannot spawn $command: $!\n";

	## ssh may ask to accept key
	#//$perltidx = $exp->expect($sshkey_timeout, 'Are you sure you want to continue connecting (yes/no)?' );
	#//$exp->send("yes\n" );
	## don't work, need more sophisticated check... rtfm!
	##  expect can match multiple patterns, with diff actions, see
	## http://search.cpan.org/~rgiersig/Expect-1.15/Expect.pod

	# *** Commands to execute on remote host is hard coded below ***
	# *** adjust acoordingly
	# *** if just one command, consider using $cmdAtDst
	$perltidx = $exp->expect($timeout, "Password: ");
	$exp->send("h7ipmiPasswordHere\n" );
	## ++FIXME++

	## $perltidx = $exp->expect($timeout, ">");
	##$exp->send("hostname\n" );

	sleep(1);
	$exp->send("\n" );
	sleep(1);
	$exp->send("\n" );
	#sleep(1);
	#$exp->send("\n" );
	$perltidx = $exp->expect($timeout, "racadm>>");
	$exp->send("racadm get BIOS.IntegratedDevices.EmbNic1\n" );

	$perltidx = $exp->expect($timeout, "racadm>>");
	$exp->send("racadm set BIOS.IntegratedDevices.EmbNic1 DisabledOs\n" );

	$perltidx = $exp->expect($timeout, "racadm>>");
	$exp->send("racadm jobqueue create BIOS.Setup.1-1    -r pwrcycle -s TIME_NOW\n" );

	$perltidx = $exp->expect($timeout, "racadm>>");
	$exp->send("\n" );
	$exp->send("exit\n" );


	#$perltidx = $exp->expect($timeout, ">");
	#$exp->send("\n" );
	#$exp->send("exit\n" );

	sleep(2);
	$exp->soft_close();

	print( "\n\n     ===== Done working on $host =====  \n" );

}

##sleep(4);	
sleep(1);		# dont really need to sleep here really
print( "     ***** All done! \n" );
print( "     ***** Reached the end, Expect session closed.  Thank you for using Expect, please come back soon!\n" );

exit 0

