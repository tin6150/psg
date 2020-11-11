#!/bin/sh

## run rclone sync to google share drive on a list of directories
## try to use tar / rclone cat ...

## script placed in /etc/cron.weekly/z...rclone_tar.sh


##LOCAL_BACKUP_LIST="/home"       # beppic-filer
##LOCAL_BACKUP_LIST="/home /eda"    # beppic-filer
LOCAL_BACKUP_LIST="/global/oldhome /eda"    # beppic-filer
##LOCAL_BACKUP_LIST="/opt/gitlab/backups"       # greyhound
#LOCAL_BACKUP_LIST="/dbbackup/mysql_backups"  # beagle
# next would benefits from having versions
#LOCAL_BACKUP_LIST="/dbbackup/mysql_backups /etc /home /clusterfs/gretadev/data"
#

##MAILTO="hpcs-logs@lbl.gov"
MAILTO="tin@lbl.gov"
#LOGFILE="/var/log/rclone_sync.log"
LOGFILE="/var/log/rclone_tar.log"


REMOTE_NAME="crypt-hpcs-backup"
ROOT_FOLDER="/"
#ROOT_FOLDER="rclone-crypt" # config file have this path embeded in it already

TRANSFER_COUNT=16
CHECKER_COUNT=16
RCLONE="/bin/rclone -v --transfers=$TRANSFER_COUNT --checkers=$CHECKER_COUNT"
##RCLONE="/bin/rclone -v"
##RCLONE="/bin/rclone --syslog"
CUR_DATE=`date +%Y%m%d`
SUM_EXIT_CODE=0

echo "====================  rclone_tar - $CUR_DATE ============"

run_rclone_push() {
        for LOCAL_BACKUP in $LOCAL_BACKUP_LIST; do
                echo "-------- Processing $LOCAL_BACKUP at $(date) --------"
                $RCLONE mkdir $REMOTE_NAME:$ROOT_FOLDER/$LOCAL_BACKUP ## > /dev/null 2>&1
                #$RCLONE --transfers=$TRANSFER_COUNT --checkers=$CHECKER_COUNT sync $LOCAL_BACKUP  ${REMOTE_NAME}:${ROOT_FOLDER}/${LOCAL_BACKUP}
		# create loop for each SUB_ITEM_LIST
		for SUB_ITEM_ENTRY in $( ls -1 $LOCAL_BACKUP ); do
			#xx SUB_ITEM_ENTRY=tin
                	echo "-------- Processing $LOCAL_BACKUP/$SUB_ITEM_ENTRY at $(date) --------"
			echo "running... cd $LOCAL_BACKUP; tar cfz - --exclude='.snapshot' $SUB_ITEM_ENTRY | $RCLONE rcat ${REMOTE_NAME}:${ROOT_FOLDER}/${LOCAL_BACKUP}/${SUB_ITEM_ENTRY}.tgz"
			cd $LOCAL_BACKUP; tar cfz - --exclude='.snapshot' $SUB_ITEM_ENTRY | $RCLONE rcat ${REMOTE_NAME}:${ROOT_FOLDER}/${LOCAL_BACKUP}/${SUB_ITEM_ENTRY}.tgz
			# ++ add --exclude='SCRATCH'
			# tar this way seems to exclude .snapshot already, but better be safe.
                	EXIT_CODE=$?
                	echo "rclone of $LOCAL_BACKUP/$SUB_ITEM_ENTRY had exit code of $EXIT_CODE"
                	SUM_EXIT_CODE=$( expr $EXIT_CODE + $SUM_EXIT_CODE )
		done
        done
        if [[ 0 -ne $SUM_EXIT_CODE  ]]; then
                echo "SUM_EXIT_CODE is $SUM_EXIT_CODE" | mail -s "WARN: $HOSTNAME : /etc/cron.../rclone_tar.sh had non zero exit code, please check" "$MAILTO"
        fi
}

run_rclone_push 2>&1 | tee -a $LOGFILE | mail -s "$HOSTNAME - rclone push" "$MAILTO"




## vim: tabstop=4 paste
