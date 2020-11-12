#!/bin/sh

## run rclone sync to google share drive on a list of directories
## this version use  tar | rclone cat ...

## script placed in /etc/cron.monthly/z...rclone_tar.sh
## this version now is ALTERNATING between EVEN and ODD months
## but is NOT doing rotation in the sense move renaming old backup or removing them if they are more than 7 days old.

## Tin 2020.11.12

LOCAL_BACKUP_LIST="/home"       # beppic-filer
##LOCAL_BACKUP_LIST="/home /eda"    # beppic-filer
#LOCAL_BACKUP_LIST="/global/oldhome /eda"    # beppic-filer
#++LOCAL_BACKUP_LIST="/home /global/oldhome /eda"    # beppic-filer
##LOCAL_BACKUP_LIST="/opt/gitlab/backups"       # greyhound
#LOCAL_BACKUP_LIST="/dbbackup/mysql_backups"  # beagle

##LOCAL_BACKUP_LIST="/etc /clusterfs/gretadev/data /global/home/users"  # beagle tar
#LOCAL_BACKUP_LIST="/etc /global/home/users /clusterfs/gretadev/data /opt /srv "  # beagle tar
#++LOCAL_BACKUP_LIST="/global/home/users /clusterfs/gretadev/data /opt"  # beagle tar
# /etc /srv are annoying as they create too many little files, so left that to the 7-day rotation script


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
SUM_EXIT_CODE=0
CUR_DATE=`date +%Y%m%d`
Month=`date +%m`
#### path Infix for Even or Odd depending on month
if [[ $(( $Month % 2 )) -eq 0 ]]; then
	Mod="Even"
else
	Mod="Odd"
fi


# tar this way seems to exclude .snapshot already, but better be safe.
#TarExclude="--exclude='.snapshot'"
TarExclude="--exclude='.snapshot' --exclude='.cache' --exclude 'SCRATCH'"


echo "====================  rclone_tar - $CUR_DATE ============"

run_rclone_push() {
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
			echo "running... cd $LOCAL_BACKUP; tar cfz - $TarExclude -- $SUB_ITEM_ENTRY | $RCLONE rcat ${REMOTE_NAME}:${ROOT_FOLDER}/$Mod/${BACKUPNAME}/${SUB_ITEM_ENTRY}.tgz"
			cd $LOCAL_BACKUP; tar cfz - $TarExclude -- $SUB_ITEM_ENTRY | $RCLONE rcat ${REMOTE_NAME}:${ROOT_FOLDER}/$Mod/${BACKUPNAME}/${SUB_ITEM_ENTRY}.tgz
			EXIT_CODE=$?
			echo "rclone of $Mod/$BACKUPNAME/$SUB_ITEM_ENTRY had exit code of $EXIT_CODE"
			SUM_EXIT_CODE=$( expr $EXIT_CODE + $SUM_EXIT_CODE )
		done
        done
        if [[ 0 -ne $SUM_EXIT_CODE  ]]; then
                echo "SUM_EXIT_CODE is $SUM_EXIT_CODE" | mail -s "WARN: $HOSTNAME : /etc/cron.../rclone_tar.sh had non zero exit code, please check" "$MAILTO"
        fi
}

run_rclone_push 2>&1 | tee -a $LOGFILE | mail -s "$HOSTNAME - rclone push - $SUM_EXIT_CODE" "$MAILTO"




## vim: tabstop=8 paste background=dark
