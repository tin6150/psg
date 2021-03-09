#!/bin/sh

## run rclone sync to google share drive on a list of directories

## adapted from scs-cm:/usr/local/bin/push_backup.sh
## not using the 7 days rotation in this version, as wwulf backup has version info already, so just sync that.


LOCAL_BACKUP_LIST="/dbbackup/mysql_backups"
# next would benefits from having versions
#LOCAL_BACKUP_LIST="/dbbackup/mysql_backups /etc /home /clusterfs/gretadev/data"
# 

MAILTO="hpcs-logs@lbl.gov"
MAILTO="tin@lbl.gov"
LOGFILE="/var/log/rclone_sync.log"


RCLONE="/bin/rclone --syslog"
REMOTE_NAME="crypt-hpcs-backup"
ROOT_FOLDER="/"
#ROOT_FOLDER="rclone-crypt" # config file have this path embeded in it already

TRANSFER_COUNT=16
CHECKER_COUNT=16
CUR_DATE=`date +%Y%m%d`
SUM_EXIT_CODE=0

echo "====================  z1_rclone_sync - $CUR_DATE ============"

run_rclone_push() {
	for LOCAL_BACKUP in $LOCAL_BACKUP_LIST; do
		echo "-------- Processing $LOCAL_BACKUP at $(date) --------"
		$RCLONE mkdir $REMOTE_NAME:$ROOT_FOLDER/$LOCAL_BACKUP > /dev/null 2>&1
		$RCLONE --transfers=$TRANSFER_COUNT --checkers=$CHECKER_COUNT sync $LOCAL_BACKUP  ${REMOTE_NAME}:${ROOT_FOLDER}/${LOCAL_BACKUP}
		EXIT_CODE=$?
		echo "rclone of $LOCAL_BACKUP had exit code of $EXIT_CODE"
		SUM_EXIT_CODE=$( expr $EXIT_CODE + $SUM_EXIT_CODE )				
	done
	if [[ 0 -ne $SUM_EXIT_CODE  ]]; then
		echo "SUM_EXIT_CODE is $SUM_EXIT_CODE" | mail -s "WARN: /etc/cron.../z1_rclone_sync.sh on $HOSTNAME had non zero exit code, please check" "$MAILTO"
	fi
}

run_rclone_push 2>&1 | tee -a $LOGFILE | mail -s "$HOSTNAME - rclone sync daily:mysql_backup - $SUM_EXIT_CODE" "$MAILTO"




## vim: tabstop=4 paste
