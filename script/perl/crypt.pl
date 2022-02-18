#!/usr/bin/perl

## #!/usr/prog/perl/5.14.1/bin/perl

# example usage: ./crypt.pl sa myPasswd
# trying trace, equiv of bash -x
# sudo cpan install "Devel::Trace"
# perl -d:Trace ./crypt.pl sa myPasswd  
# -or-
# PERLDB_OPTS="NonStop AutoTrace" perl -d ./crypt.pl sa myPasswd | tee trace.out # but can't capture full output to file  see PSG/perl.html
# https://stackoverflow.com/questions/3852395/is-there-a-way-to-turn-on-tracing-in-perl-equivalent-to-bash-x

my( $en );
#$en = crypt( "welcome1", "wl");
#$en = crypt( "N0vart!s", "N0");
#$en = crypt( "FixMyPw!", "pw");
#$en = crypt( @_[0], "wl");


$en = crypt( "$ARGV[0]", "$ARGV[1]");
print "arg 0 (pass):  $ARGV[0] \n";
print "arg 1 (salt):  $ARGV[1] \n";
print "shadow crypt:  $en\n";


