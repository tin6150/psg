#!/bin/sh

## run rclone sync to google share drive on a list of directories
## this version intended for manual trigger to backup my own files

# brc>
module load rclone/1.58.1

##rclone lsd dchiang50gdrv:    # this ran out of space quickly
##rclone lsd tinberk:          # this was not authorized for dtn.brc, then also failed on bofh... *sigh* need to check...



## rclone lsd dchiang50gdrv:/RCLONE_BK_via_SYNC
## rclone lsd dchiang50gdrv:/RCLONE_BK_via_SYNC/global/scratch/users/tin/fc_graham/PRISA/Assemblies/
## adapted from z1_rclone_sync.sh


## ++CHANGE_ME++
LOCAL_BACKUP_LIST="/global/scratch/users/tin/fc_graham/PRISA/Assemblies/animal"
LOCAL_BACKUP_LIST="$LOCAL_BACKUP_LIST /global/scratch/users/tin/fc_graham/PRISA/Assemblies/anim66"
#LOCAL_BACKUP="/global/scratch/users/tin/fc_graham/PRISA/Assemblies"

 
RCLONE="rclone"
REMOTE_NAME="dchiang50gdrv"
ROOT_FOLDER="/RCLONE_BK_via_SYNC"
#ROOT_FOLDER="rclone-crypt" # config file have this path embeded in it already

LOGFILE="/global/scratch/users/tin/LOG/rclone_sync_manual.log"
MAILTO="tin@berkeley.edu"

TRANSFER_COUNT=16
CHECKER_COUNT=16
CUR_DATE=`date +%Y%m%d`
SUM_EXIT_CODE=0


echo "====================  rclone_sync_manual - $CUR_DATE ============"

# noFn wrapper
#run_rclone_push() {
	for LOCAL_BACKUP in $LOCAL_BACKUP_LIST; do
		echo "-------- Processing $LOCAL_BACKUP at $(date) --------"
		$RCLONE mkdir $REMOTE_NAME:$ROOT_FOLDER/$LOCAL_BACKUP ## > /dev/null 2>&1
		$RCLONE --transfers=$TRANSFER_COUNT --checkers=$CHECKER_COUNT sync $LOCAL_BACKUP  ${REMOTE_NAME}:${ROOT_FOLDER}/${LOCAL_BACKUP} | tee -a $LOGFILE
		EXIT_CODE=$?
		echo "rclone of $LOCAL_BACKUP had exit code of $EXIT_CODE"
		SUM_EXIT_CODE=$( expr $EXIT_CODE + $SUM_EXIT_CODE )				
	done
	if [[ 0 -ne $SUM_EXIT_CODE  ]]; then
		echo "SUM_EXIT_CODE is $SUM_EXIT_CODE" | mail -s "WARN: tin@BRC rclone_sync_manual.sh on $HOSTNAME had non zero exit code, please check" "$MAILTO"
	fi
#}

#noFn#run_rclone_push 2>&1 | tee -a $LOGFILE | mail -s "$HOSTNAME - rclone sync manual tin@brc - $SUM_EXIT_CODE" "$MAILTO"




## vim: tabstop=4 paste
