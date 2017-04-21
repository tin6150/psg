#!/usr/prog/perl/5.10.1/bin/perl

## #!/usr/bin/perl


use Expect;
use warnings;
use strict;

print "Expect module available... Good, spawning ssh sessions now...\n";

##my $command = "/bin/hostname";
my $command = "ssh somehostname";
#my @params = ("localhost");
my $perltidx;
my $sshkey_timeout = 4;
my $timeout = 30;
#my @match_patterns = ">";

my @hostlist;
#push( @hostlist, "linux-tin2" );
#push( @hostlist, "phusem-vml-pathach1" );
#my @hostlist = ("linux-tin2", "phusem-vml-pathach1" );
my @esx_hostlist = ("vmusca10sc" );

@hostlist = @esx_hostlist;


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
	$command = "ssh $host";
	$exp->spawn( $command ) or die "Cannot spawn $command: $!\n";
	##$exp->spawn( "ssh localhost" ) or die "Cannot spawn $command: $!\n";

	## ssh may ask to accept key
	$perltidx = $exp->expect($sshkey_timeout, 'Are you sure you want to continue connecting (yes/no)?' );
	$exp->send("yes\n" );
	## don't work, need more sophisticated check... rtfm!
	##  expect can match multiple patterns, with diff actions, see
	## http://search.cpan.org/~rgiersig/Expect-1.15/Expect.pod

	$perltidx = $exp->expect($timeout, ">");
	$exp->send("hostname\n" );
	$perltidx = $exp->expect($timeout, ">");
	$exp->send("uptime\n" );
	$perltidx = $exp->expect($timeout, ">");
	$exp->send("\n" );
	$exp->send("exit\n" );

	sleep(2);
	$exp->soft_close();

	print( "\n\n     ===== Done working on $host =====  \n" );

}

sleep(4);
print( "     ***** All done! \n" );
print( "     ***** Reached the end, Expect session closed.  Thank you for using Expect, please come back soon!\n" );

exit 0

