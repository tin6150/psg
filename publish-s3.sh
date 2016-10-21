#!/bin/bash 

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
#aws s3 sync .        s3://sapsg/       --acl public-read
aws s3 sync .        s3://tin6150/       --acl public-read
