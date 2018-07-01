#!/usr/bin/perl

## #!/usr/prog/perl/5.14.1/bin/perl


my( $en );
#$en = crypt( "welcome1", "wl");
#$en = crypt( "N0vart!s", "N0");
#$en = crypt( "FixMyPw!", "pw");
#$en = crypt( @_[0], "wl");


$en = crypt( "$ARGV[0]", "$ARGV[1]");
print "arg 0 (pass):  $ARGV[0] \n";
print "arg 1 (salt):  $ARGV[1] \n";
print "shadow crypt:  $en\n";


