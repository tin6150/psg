#!/usr/bin/perl

## usage: /path/to/path_change.pl 
## run against all file in current dir

my( @file_list, $oneFile );
my( $tmpFileName ) = "sn50.tmp";
my( $i ) = 0;

my( $oldStr ) = "\/user\/cheminfor";
my( $newStr ) = "\/usem\/home\/cheminfor";

@file_list = qx/ls -1/;
while( scalar @file_list >= 1 ) {
	$oneFile = pop( @file_list );
	print( "Processing file No. $i: $oneFile" );
	$i++;

	open( TmpFH, ">",  $tmpFileName ) || die "Cannot write to tmp file\n";
	open( FH, $oneFile ) || die "Cannot open input file\n";
	##!!print( TmpFH "testing 123\n" );
	while( <FH> ) {
		s/^testing\ 123$//;
 		s/$oldStr/$newStr/g ;
		print TmpFH $_ ;
	}
	close( FH );
	close( TmpFH );
	system( "mv $tmpFileName $oneFile" );
}


