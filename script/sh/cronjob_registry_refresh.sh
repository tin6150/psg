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

# 30 8  1  *  *  /home/tin/tin-gh/psg/script/sh/cronjob_registry_refresh.sh
# entry in crontab for lunaria for root (cuz docker on bofh need root)

# run docker pull on my images once in a while
# before docker purge them after 6 months

# aw crap, may need docker login... or run from non saturated IP...

PullCmd="docker pull"
#PullCmd="sudo podman pull"

ImgList="r4eta r4envids metabolic perl4metabolic base4metabolic bioperl bioperl-centos-8 adjoin cmaq os4cmaq lib4cmaq c7tools satools apache_psg_3a apache_psg3" 

date

for Img in $ImgList; do
	echo Running : $PullCmd $Img
	$PullCmd $Img
	echo $?
done


date


