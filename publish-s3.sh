#!/bin/bash 

# !! in x1carb, need to run this on a cygwin bash that has aws cli configured.
#    the psg sym link in this cygwin works.
#
# moba wasn't configured and probably had problem getting it
# maybe can get it to work on MINGW64/git-bash, 
# but this is the pain of this dev in windows not having proper linux support!

cp -p psg2.html psg.html
cp -p psg2.html index.html
## linux dropbox tends to change file perm to 000 !! :(
find  . -type d -exec chmod a+rx,u+rwx {} \;
find  . -type f -exec chmod a+r,u+rw {} \;

## test deploy to aws s3 t6@g acc 
## for now to sapsg, but eventually to tin6150, which is actually where i have published the web site.

# http://tin6150.s3-website-us-west-1.amazonaws.com/     # tiny.cc/TIN   in resume to genentech
#aws s3 ls s3://tin6150
# http://sapsg.s3-website-us-west-1.amazonaws.com/
#aws s3 ls s3://sapsg

#aws s3 sync conf     s3://sapsg/conf   --acl public-read
# this will recursively copy everything from  current dir.  ensure run this in the psg/ folder !!
# sync is like rsync, so a second run, sync files won't be xfered again.
#aws s3 sync .        s3://sapsg/       	--acl public-read
#aws s3 sync .        s3://tin6150/       	--acl public-read
aws s3 sync .        s3://psg.ask-margo.com/    --acl public-read
