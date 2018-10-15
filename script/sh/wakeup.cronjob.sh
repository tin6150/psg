#!/bin/sh 


PATH=/usr/local/hb/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/X11/bin
MAILTO=bofh@example.com

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name command to be executed

# 30 8  *  *  mon  /home/tin/tin-gh/psg/script/sh/wakeup.cronjob.sh
# entry in crontab for lunaria for me (not root)

# lunaria get used once a week, and it is very slow for a long time
# it is not just cuz hd was spun down.
# all cache expired and need to be reread?
# hopefully this job wakes it up.
# firefox was hogging lots of RAM, like 7G (out of 8G on the machine).
# so may not be much better than chrome.


date
if [ -d ~/PSG ]; then
	cd ~/PSG
	git pull
fi

if [ -d ~/tin-gh ]; then
	cd ~/tin-gh
	find . -exec file {} \; > /dev/null 2>&1 
fi

find ~ 		> /dev/null  2>&1 
find /bin  	> /dev/null  2>&1 
date


