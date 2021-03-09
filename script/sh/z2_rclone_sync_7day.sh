#!/bin/bash

## greyhound:/etc/cron.daily/z2_rclone_sync_7day.sh
## run tar | rclone rcat to google share drive on a list of directories
## this version keep a 7 days rotation of the files
## adapted from scs-cm:/usr/local/bin/push_backup.sh
## Tin 2020.1012

#LOCAL_BACKUP_LIST="/etc"
LOCAL_BACKUP_LIST="/etc /opt/gitlab/config"   ## be careful that $LOCAL_BACKUP_LIST/.. is indeed the parent for tar $SUB_ITEM_ENTRY to work
#LOCAL_BACKUP_LIST="/etc /global/home/users /opt/gitlab/config" # may blow 400k file limit

MAILTO="hpcs-logs@lbl.gov"
MAILTO="tin@lbl.gov"
LOGFILE="/var/log/rclone_sync_7day.log"

TarExclude="--exclude='.snapshot' --exclude='.cache'"
#RCLONE="/bin/rclone --syslog"
RCLONE="/bin/rclone -v"
#RCLONE="/bin/rclone -q"
REMOTE_NAME="crypt-hpcs-backup"
## rclone endpoint crypt-hpcs-backup is hpcs-backup :: rclone/beagle.lbl.gov/rclone-crypt 
TRANSFER_COUNT=16
CHECKER_COUNT=16
ROOT_FOLDER="/rotation"



run_rclone_push() {


	CUR_DATE=`date +%Y%m%d`


	SUM_EXIT_CODE=0

	echo "====================  z2_rclone_sync_7day - $CUR_DATE ============"

	for BACKUP_ITEM in $LOCAL_BACKUP_LIST; do
		BACKUPNAME=$( echo $BACKUP_ITEM | sed 's^/^_^g' )
		echo "---- Processing $BACKUP_ITEM as $BACKUPNAME at $(date) ----"

		##REMOTE_BACKUP_LIST=`$RCLONE lsd $REMOTE_NAME:$ROOT_FOLDER/$BACKUPNAME | awk '{print $5}'`
		REMOTE_BACKUP_LIST=`$RCLONE lsd $REMOTE_NAME:$ROOT_FOLDER/$BACKUPNAME | awk '{print $5}'`

		LATEST_REMOTE_BACKUP=`echo "$REMOTE_BACKUP_LIST" | head -1`
		PURGE_LIST="$REMOTE_BACKUP_LIST"

		#Don't run if we already have the current day's backup (just sanity checking)
		#Actually, purge it if it exist (which remains in trash can for a bit)
		#then run the backup.  Don't want to skip if something failed and need a re-run!
		CUR_EXISTS=`echo "$REMOTE_BACKUP_LIST" | grep $CUR_DATE`

		if [ x"$CUR_EXISTS" != x"" ]; then
			echo "---- Found existing backup with today's dir, COULD purge but WONT: $RCLONE purge $REMOTE_NAME:$ROOT_FOLDER/$BACKUPNAME/$CUR_DATE"
			#-- echo $RCLONE purge $REMOTE_NAME:$ROOT_FOLDER/$BACKUPNAME/$CUR_DATE 
		fi	
		$RCLONE mkdir $REMOTE_NAME:$ROOT_FOLDER/$BACKUPNAME/$CUR_DATE > /dev/null 2>&1
		##//echo about to run: $RCLONE --transfers=$TRANSFER_COUNT --checkers=$CHECKER_COUNT sync $BACKUP_ITEM $REMOTE_NAME:$ROOT_FOLDER/$BACKUPNAME/$CUR_DATE 
		##//$RCLONE --transfers=$TRANSFER_COUNT --checkers=$CHECKER_COUNT sync $BACKUP_ITEM $REMOTE_NAME:$ROOT_FOLDER/$BACKUPNAME/$CUR_DATE > /dev/null 2>&1
		SUB_ITEM_ENTRY=$(basename $BACKUP_ITEM)
		echo "---- running:: cd ${BACKUP_ITEM}/..; tar cfz - $TarExclude $SUB_ITEM_ENTRY | $RCLONE rcat ${REMOTE_NAME}:${ROOT_FOLDER}/${BACKUPNAME}/${CUR_DATE}/${SUB_ITEM_ENTRY}.tgz"
		cd ${BACKUP_ITEM}/..; tar cfz - $TarExclude $SUB_ITEM_ENTRY | $RCLONE rcat ${REMOTE_NAME}:${ROOT_FOLDER}/${BACKUPNAME}/${CUR_DATE}/${SUB_ITEM_ENTRY}.tgz
		EXIT_CODE=$?
		echo "rclone of $BACKUPNAME had exit code of $EXIT_CODE"
		SUM_EXIT_CODE=$( expr $EXIT_CODE + $SUM_EXIT_CODE )

		#// $RCLONE mkdir $REMOTE_NAME:$ROOT_FOLDER/$BACKUPNAME/$CUR_DATE > /dev/null 2>&1
		#// $RCLONE --transfers=$TRANSFER_COUNT --checkers=$CHECKER_COUNT sync $LOCAL_BACKUPS $REMOTE_NAME:$ROOT_FOLDER/$BACKUPNAME/$CUR_DATE > /dev/null 2>&1

		DATE0=`date +%Y%m%d`
		DATE1=`date -d 'now - 1 days' +%Y%m%d`
		DATE2=`date -d 'now - 2 days' +%Y%m%d`
		DATE3=`date -d 'now - 3 days' +%Y%m%d`
		DATE4=`date -d 'now - 4 days' +%Y%m%d`
		DATE5=`date -d 'now - 5 days' +%Y%m%d`
		DATE6=`date -d 'now - 6 days' +%Y%m%d`
		DATE7=`date -d 'now - 7 days' +%Y%m%d`
		DATE8=`date -d 'now - 14 days' +%Y%m%d`
		DATE9=`date -d 'now - 21 days' +%Y%m%d`
		DATE10=`date -d 'now - 28 days' +%Y%m%d`
		DATE11=`date -d 'now - 35 days' +%Y%m%d`


		INTDATE="$DATE0"
		##for i in `seq 1 7`; do
		for i in `seq 1 11`; do
			eval NEWINTDATE=\$DATE$i
			INTDATE="$INTDATE $NEWINTDATE"
		done

		# purge not  developed yet -- placeholder code for now  ++FIXME++

		#Purge old crap, exclude latest backup (no matter if it's ancient) from purge
		for i in $INTDATE; do
			PURGE_LIST=`echo "$PURGE_LIST" | grep -v "$i" | grep -v "$LATEST_REMOTE_BACKUP"`
		done

		#Make sure we have at least one backup remaining (never purge the last)
		if [ "$REMOTE_BACKUP_LIST" != "" ]; then
			if [ "$PURGE_LIST" != "" ]; then
				for n in $PURGE_LIST; do
					##//$RCLONE purge $REMOTE_NAME:$ROOT_FOLDER/$BACKUPNAME/$n
					echo $RCLONE purge $REMOTE_NAME:$ROOT_FOLDER/$BACKUPNAME/$n
				done
			fi
		fi

	done # for loop across BACKUP_LIST
	echo "====================  z2_rclone_sync_7day - completing - $(date)  ============"
	if [[ 0 -ne $SUM_EXIT_CODE  ]]; then
		echo "rclone sum_exit_code: $SUM_EXIT_CODE" | mail -s "WARN: /etc/cron.daily/z2_rclone_sync_7day.sh on $HOSTNAME had non zero exit code, please check" "$MAILTO"
	fi

} # end function run_rclone_push

time run_rclone_push 2>&1 | tee -a $LOGFILE | mail -s "$HOSTNAME - rclone push 7 day rotation" "$MAILTO"


## vim: tabstop=4 paste 
