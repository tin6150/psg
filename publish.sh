#!/bin/bash 


# now that stuff are in git, no need to scp files from local computer.
# have also setup a cronjob, so can likely just not worry about this
ssh bofh@dallas180.arvixeshared.com /home/bofh/psg_git_pull.sh
#cd /home/bofh/public_html/tin-gh/psg && git pull
# # git clone https://github.com/tin6150/psg

exit 0





cp -p psg2.html psg.html
cp -p psg2.html index.html
## linux dropbox tends to change file perm to 000 !! :(
## probably not needed anymore, as not in dropbox folder anymore...  takes a long time to run...
#find  . -type d -exec chmod a+rx,u+rwx {} \;
#find  . -type f -not -path ".git" -exec chmod a+r,u+rw {} \;

MAQUINA=$(hostname)

if [[ $MAQUINA == "PHUSEM-L43453" && $HOME == "/home/mobaxterm" ]]; then
	scp -pr * bofh@stats.dunlin.arvixe.com:public_html/psg/

	# mobaxterm can't seems to handle above cascaded cmd in ssh (or new jailshell in dunlin don't let me?  


	# try the good old way...
	# commands works when pasted, but not in script.... something bout ssh_askpass exec...
	ssh -x bofh@stats.dunlin.arvixe.com  "find  public_html/psg -type d -exec chmod a+rx,u+rwx {} \;"
	ssh -x bofh@stats.dunlin.arvixe.com  "find  public_html/psg -type f -exec chmod a+r,u+rw {} \;"
	ssh -x bofh@stats.dunlin.arvixe.com  chmod -R a+r,u+w  public_html/psg/
	## -x:  disable X11 fwd
	## also changed .bashrc not to source /etc/bashrc as there is some bug there

else
#if [[ $MAQUINA == "backbay" ]]; then
	## backbay ssh key req pw, so chain the ssh commands into one.  ssh-agent doesn't help.
	## cygwin in x1carb also ask for pw... till ssh key work in there...
	scp -pr * bofh@stats.dunlin.arvixe.com:public_html/psg/
	echo "scp done"
	ssh -x bofh@stats.dunlin.arvixe.com  "chmod -R a+r,u+w  public_html/psg/ 	&& \
		find  public_html/psg -type d -exec chmod a+rx,u+rwx {} \; 		&& \
		find  public_html/psg -type f -exec chmod a+r,u+rw {} \;		&& \
		chmod -R a+r,u+w  public_html/psg/"

#else
#	echo "host not coded for xfer, run cmd manually... "
fi
exit 0


##scp -pR * sn50@shell.sonic.net:public_html/psg/

## amazon ec2 that no longer exist??   used in Nov 2015 ??
## 104.197.147.249 is somewhere in googleusercontent.com...
#scp -pr  * tin6150@104.197.147.249:psg
#ssh tin6150@104.197.147.249 sudo mv psg/* /var/www/html
#ssh tin6150@104.197.147.249 sudo cp -p /var/www/html/psg2.html /var/www/html/index.html
# SElinux need change context type of files after being copied...
#ssh tin6150@104.197.147.249 sudo chcon -vR --type=httpd_sys_content_t /var/www/html
# sestatus; ls -lZ /var/www/html/index.html; ps -efZ


## really old stuff in Publish
#pscp -p [a-z]* tho01@goliath.cs.fiu.edu:public_html/psg/

# scp -pr [a-z]* tho01@solix:www/psg
# scp -pr * tin@seele.tokyo3.com:html/psg
