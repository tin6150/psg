#!/usr/bin/perl

use Fcntl qw(:flock SEEK_END);  # import LOCK_* constatnts


#FH;

#open( FH, "./test.txt" );
print( "opening file... \n" );
#open( FH, ">> /home/chemist/vnmrsys/data/hoti1/DIR_INFO.text" );
open( FH, ">> /home/chemist/vnmrsys/data/auto_2010.03.23/enterQ" );
#open( FH, ">> ./currentDirLockTest.tmp" );
 
print( "locking file... \n" );
flock( FH, LOCK_EX ) or die "Cannot flock \n" ;

print( "reading file... \n" );


## this while loop is buggy, but it now works as pause
## so that another instance of this program can run and stay in lock wait condition...
while() 
{
        print $_;
}
print( "unlocking file... \n" );
flock( FH, LOCK_UN ) or die "Cannot unlock flock \n" ;
close( FH );
print( "file closed succesfully. \n" );

