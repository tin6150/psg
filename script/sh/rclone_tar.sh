#!/bin/sh

#--exit 007
## tmp hold till first run is completed ++

## run rclone sync to google share drive on a list of directories
## this version use  tar | rclone cat ...

## script placed in /etc/cron.monthly/rclone_tar.sh
## this version now is ALTERNATING between EVEN and ODD months
## but is NOT doing rotation in the sense move renaming old backup or removing them if they are more than 7 days old.

## Tin 2020.12.03, add:
## check for rcat status, if get error cuz hit g-drive daily limit, sleep and wait and loop
## Tin 2020.12.23, add:
## only retry on exit 403 which is rate exceeded, move on for other exit code

## Tin 2021.05283, add:
## echo list out, echo finish status
## 2021.04... ran from 4/26 to 5/17, need to check if complete...
##   rclone of Even/_global_data_scratch_lrc_SARMAP_LAY27_LingOpt/EP209 had exit code of 5
## 2021.0519, still running as of 2021.0528
## June: changing to use specific cronjob that starts on 2nd of the month, cron.monthly is too unpredictable
##   0  1  2  *  *            /root/rclone_script/rclone_tar.sh 

## Tin 2021.07.23, slight tewaks for backup dirs for beagle

##LOCAL_BACKUP_LIST="/home"       # beppic-filer
##LOCAL_BACKUP_LIST="/home /eda"    # beppic-filer
#LOCAL_BACKUP_LIST="/global/oldhome /eda"    # beppic-filer
#++LOCAL_BACKUP_LIST="/home /global/oldhome /eda"    # beppic-filer

##LOCAL_BACKUP_LIST="/opt/gitlab/backups"       # greyhound

# LOCAL_BACKUP_LIST="/dbbackup/mysql_backups"  # beagle - rclone in cron.daily
# /etc /srv are annoying as they create too many little files, so left that to the 7-day rotation script
#++LOCAL_BACKUP_LIST="/global/home/users /clusterfs/gretadev/data /opt"  # beagle tar  
LOCAL_BACKUP_LIST="/var/chroots /srv /global/home/users /clusterfs/gretadev/data /opt"  # beagle tar # include vnfs wwulf httpd content

## list updated 2021.0322
HIMA_LOCAL_BACKUP_LIST="/etc /global/home \
  /global/data/goddess /global/data/home-gpanda /global/data/mariah /global/data/mariahdata \
  /global/data/seasonal /global/data/seasonal2 /global/data/transportation /global/data/usrbackup \
    /global/data/gpanda/pghuy /global/data/gpanda/wzhou /global/data/gpanda/yhanw \
  /global/data/gpanda/lbastien \
  /global/data/gpanda/ljin \
  /global/data/gpanda/ljin_Shared/Shared \
  /global/data/scratch_lrc/lucas \
  /global/data/scratch_lrc/yuhan_wang \
  /global/data/scratch_lrc/SFDomain \
    /global/data/scratch_lrc/SARMAP/LAY27_LingOpt \
    /global/data/scratch_lrc/SARMAP/LAY35_LingOpt"  
#### above yield 21 .tgz by rcat/rclone.  2021-04 seems a complete backup, from 4/26 to 5/8

## list to be re-added once sizing work for rlcone   /global/data/scratch_lrc/SARMAP/ was too big for 2021Mar8 LAY35_LingOpt
## ~7 TB is largest so far, actually, that was dir with many files
## LAY35_LingOpt is 9.2 T... with dirs dizes 1.8T to 2.8T
# hima, gpanda/ljin is 7T, ljin_Shared is 13T  gpanda/lbastien is 4.4T
TMP_DISABLED_PARTIAL_LIST_4_LOCAL_BACKUP_LIST="
"


###LOCAL_BACKUP_LIST="/etc /global/home "  # hima, these should be in crypt-hpcs-backup
#LOCAL_BACKUP_LIST="/etc /global/home /global/data/buddha /global/data/ccosemis /global/data/ccosemis-off /global/data/goddess /global/data/home-gpanda /global/data/mariah /global/data/mariahdata /global/data/seasonal /global/data/seasonal2 /global/data/transportation /global/data/usrbackup /global/data/gpanda/pghuy /global/data/gpanda/wzhou /global/data/gpanda/yhanw /global/data/gpanda/lbastien /global/data/gpanda/ljin /global/data/gpanda/ljin_Shared/Shared /global/data/scratch_lrc/lucas /global/data/scratch_lrc/yuhan_wang /global/data/scratch_lrc/SFDomain /global/data/scratch_lrc/SARMAP"  # hima, gpanda/ljin is 7T, ljin_Shared is 13T  gpanda/lbastien is 4.4T
##~~LOCAL_BACKUP_LIST="/global/data/gpanda/ljin /global/data/gpanda/ljin_Shared/Shared /global/data/scratch_lrc/lucas /global/data/scratch_lrc/yuhan_wang /global/data/scratch_lrc/SFDomain /global/data/scratch_lrc/SARMAP"   # priority list ran manually Mar8

#LOCAL_BACKUP_LIST="/global/data/gpanda /global/data/home-gpanda /global/data/mariah /global/data/mariahdata /global/data/seasonal /global/data/seasonal2 /global/data/transportation /global/data/usrbackup     /etc /global/home /global/data/buddha /global/data/ccosemis /global/data/ccosemis-off /global/data/goddess"  # hima (alt ordering)

##  a tar will be created, so it will be big.  but many many of those /global/data better off not encrypted
## the list is from /etc/fstab

# next would benefits from having versions
#LOCAL_BACKUP_LIST="/dbbackup/mysql_backups /etc /home /clusterfs/gretadev/data"
#

##MAILTO="hpcs-logs@lbl.gov"
MAILTO="tin@lbl.gov"

#LogPrefix="/var/log/rclone_sync_log"
LogPrefix="/var/log/rclone_tar_log"


PROG=rclone_tar
PidFile="/var/lock/$PROG"


REMOTE_NAME_NoCrypt="hpcs-backup"   # for logs only
#REMOTE_NAME="hpcs-backup"          # for machines not wanting encryption, eg hima
REMOTE_NAME="crypt-hpcs-backup"     # beagle
ROOT_FOLDER="/"						# config file store in "/rclone-crypt" folder

TRANSFER_COUNT=16
CHECKER_COUNT=16
RCLONE="/bin/rclone -v --transfers=$TRANSFER_COUNT --checkers=$CHECKER_COUNT"
##RCLONE="/bin/rclone -v"
##RCLONE="/bin/rclone --syslog"
SUM_EXIT_CODE=0
CUR_DATE=`date +%Y%m%d`
LOGFILE=$LogPrefix.$CUR_DATE.txt
Month=`date +%m`
#### path Infix for Even or Odd depending on month
if [[ $(( $Month % 2 )) -eq 0 ]]; then
	Mod="Even"
else
	Mod="Odd"
fi

#-- TMP manual modifier  ++ CHANGE_ME ++
##Mod=2020dec23
##Mod=2021jan13
##Mod=2021mar8
##Mod=2021mar22

# tar this way seems to exclude .snapshot already, but better be safe.
#TarExclude="--exclude='.snapshot'"
TarExclude="--exclude='.snapshot' --exclude='.cache' --exclude 'SCRATCH'"

MaxTry=60 # 57 tries 50 min apart will be 2 days
RetryWait=3060 # 51 minutes




echo "====================  rclone_tar - $CUR_DATE ============"

run_rclone_push() {
	echo "==Starting subroutine run_rclone_push() on $(date)" 
	echo "==LOCAL_BACKUP_LIST set to --$LOCAL_BACKUP_LIST--"
	echo "==number of entries in list is... " # expect 21 as of 2021.0528
	echo "$LOCAL_BACKUP_LIST " | sed 's/\ /\n/g' | grep -v '^$' | wc -l

	for LOCAL_BACKUP in $LOCAL_BACKUP_LIST; do
		BACKUPNAME=$( echo $LOCAL_BACKUP | sed 's^/^_^g' )
		echo "-------- Processing $LOCAL_BACKUP at $(date) --------"
		#--$RCLONE mkdir $REMOTE_NAME:$ROOT_FOLDER/$LOCAL_BACKUP ## > /dev/null 2>&1
		# eg  crypt-hpcs-backup://global/oldhome 
		$RCLONE mkdir $REMOTE_NAME:$ROOT_FOLDER/$Mod/$BACKUPNAME ## > /dev/null 2>&1
		# eg   crypt-hpcs-backup://Even/global_oldhome 
		# NOT  crypt-hpcs-backup://global_oldhome/Even # cuz then maybe lost among a dir with many files

		#$RCLONE --transfers=$TRANSFER_COUNT --checkers=$CHECKER_COUNT sync $LOCAL_BACKUP  ${REMOTE_NAME}:${ROOT_FOLDER}/${LOCAL_BACKUP}
		# create loop for each SUB_ITEM_LIST
		for SUB_ITEM_ENTRY in $( ls -1 $LOCAL_BACKUP ); do
			#xx SUB_ITEM_ENTRY=tin
			echo "-------- Processing $Mod/$BACKUPNAME/$SUB_ITEM_ENTRY at $(date) --------"
			EXIT_CODE=1
			TRIAL=1
			while [[ $EXIT_CODE -ne 0 && $TRIAL -lt $MaxTry ]]; do
				echo "running... cd $LOCAL_BACKUP; tar cfz - $TarExclude -- $SUB_ITEM_ENTRY | $RCLONE rcat ${REMOTE_NAME}:${ROOT_FOLDER}/$Mod/${BACKUPNAME}/${SUB_ITEM_ENTRY}.tgz"
				cd $LOCAL_BACKUP; tar cfz - $TarExclude -- $SUB_ITEM_ENTRY | $RCLONE rcat ${REMOTE_NAME}:${ROOT_FOLDER}/$Mod/${BACKUPNAME}/${SUB_ITEM_ENTRY}.tgz
				EXIT_CODE=$?
				# seems like capturing tar EXIT_CODE rather than rclone, so this mechanism may not work.
				if [[ EXIT_CODE -eq 403 || EXIT_CODE -eq 1 ]]; then
					# 403 is rate limit exceeded, so worth retrying
					echo "Non 0 EXIT_CODE ($EXIT_CODE), sleeping $RetryWait before retry -- $(date)"
					sleep $RetryWait
					TRIAL=$((TRIAL + 1))
				elif [[ EXIT_CODE -ne 0 ]]; then
					echo "Non 0 EXIT_CODE ($EXIT_CODE), but not retrying -- $(date)"
					TRIAL=${MaxTry} # set to last trial so that it would exit while loop and onto next item
				fi
			done

			echo "rclone of $Mod/$BACKUPNAME/$SUB_ITEM_ENTRY had exit code of $EXIT_CODE"
			SUM_EXIT_CODE=$( expr $EXIT_CODE + $SUM_EXIT_CODE )
		done
	done
	if [[ 0 -ne $SUM_EXIT_CODE  ]]; then
		echo "SUM_EXIT_CODE is $SUM_EXIT_CODE" | mail -s "WARN: $HOSTNAME : /etc/cron.../rclone_tar.sh had non zero exit code, please check" "$MAILTO"
	fi

	echo "==Completed subroutine run_rclone_push() on $(date)" 
}


########################################
########################################
#### "main"
########################################
########################################

if [[ -f $PidFile ]] ; then
	echo "PID file $PidFile exist, exiting"
	exit 1
else
	touch $PidFile
	date >> $PidFile
	#run_rclone_push 2>&1 | tee -a $LOGFILE | mail -s "$HOSTNAME - rclone_tar/rcat monthly" "$MAILTO"
	run_rclone_push 2>&1 | tee -a $LOGFILE
	RcloneExit=$?
	echo "RcloneExit is $RcloneExit" >> $PidFile
	date >> $PidFile
	echo "====================" >> $PidFile
	if [[ $RcloneExit -ne 0 ]]; then
		# only mail if non exit code
		cat $PidFile $LOGFILE | mail -s "$HOSTNAME - nonzero WARN: $RcloneExit - rclone_tar/rcat monthly" "$MAILTO" 
	fi
	$RCLONE mkdir ${REMOTE_NAME_NoCrypt}:/log
	$RCLONE copy $LOGFILE ${REMOTE_NAME_NoCrypt}:/log
	$RCLONE copy $PidFile ${REMOTE_NAME_NoCrypt}:/log  # PidFile is overwritten every time, it is okay, don't want to keep too many
	# rclone encounter // will create a "New Folder" in google drive

	rm $PidFile
	#rm $LOGFILE
fi


exit


##
## rclone exit code
## 

## these can sleep and retry:
##2020/12/14 20:21:17 Failed to rcat: googleapi: Error 403: User rate limit exceeded., userRateLimitExceeded





## -------- Processing 2020dec23/_global_data_goddess/www at Tue Jan  5 21:58:21 PST 2021 --------
## running... cd /global/data/goddess; tar cfz - --exclude='.snapshot' --exclude='.cache' --exclude 'SCRATCH' -- www | /bin/rclone -v --transfers=16 --checkers=16 rcat hpcs-backup://2020dec23/_global_data_goddess/www.tgz
## 2021/01/05 21:58:22 Failed to rcat: googleapi: Error 403: User rate limit exceeded., userRateLimitExceeded
## Non 0 EXIT_CODE (1), but not retrying -- Tue Jan  5 21:58:22 PST 2021

## so far only 1 Error 413: Request Too Large, uploadTooLarge
## which was for 
## running... cd /global/data/gpanda; tar cfz - --exclude='.snapshot' --exclude='.cache' --exclude 'SCRATCH' -- ljin | /bin/rclone -v --transfers=16 --checkers=16 rcat hpcs-backup://2020dec11/_global_data_gpanda/ljin.tgz
## 2020/12/22 18:29:19 Failed to rcat: googleapi: Error 413: Request Too Large, uploadTooLarge
#### broke down data/gpanda, hopefully ljin/* is good enough.  else, may have to ask if Lin wants to split Shared , with another high level break down at /global/data/gpanda/ljin/Shared/ADJ_Team/scratch_lrc/SARMAP/LAY35_LingOpt


# vim: tabstop=4 paste background=dark noexpandtab
