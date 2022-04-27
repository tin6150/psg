#!/bin/sh


## script to fdisk sda of a node 
## when it is first installed (or when hd has been replaced)
## Originally by Bernard Li,
## slightly modified, as there seems to be some typo... -Tin 2017.0711
## last significant change 2018.0824 (added sanity check fn)
## 1st loc: psg/script/hpc/
## 2nd loc: tin-bb/blpriv/hpcs_toolkit

### slightly updated 2022.0426
### from perceus:/global/home/groups/scs/disks/part_disks.sh 
### 2021.1105 added test for SD_NAME cuz cut-n-paste may miss it 
### 2020.1027 slightly updated mkdir /local/log
### 2022.0426 for greta vnfs has /var/lib/docker -> /local/docker

#### 2020.0810
#### run as:
#### ./part_disks.sh sda   # single sda, traditional setup
#### ./part_disks.sh ssd   # single /dev/nvme0n1, otherwise same setup as sda
#### ./part_disks.sh mms      # mirror sda, sdb.  ssd on sdc  eg n0174.sav3
#### ./part_disks.sh 3d       # 3 disks raid, tbd (check on HPCS_TOOLKIT/raid_part_disks.sh )


############################################################
# sanity check make sure running fdisk on expected machine (ie nodes)
############################################################

run_sanity_check() 
{

	MAQUINA=$(hostname)
	if [[ x$MAQUINA == "perceus-00.scs.lbl.gov" ]]; then
		echo "DO NOT run here!"
		exit 007
	fi


	# this regex is good enough, acc for greta nodes naming scheme
	if [[ x$MAQUINA =~ x[ncsw][0-9][0-9][0-9][0-9] ]]; then
		echo "hostname pattern passes sanity test, continuting..." # ie not causing an abort/exit
		#run_fdisk_cmd  # no () in bash fn call!
		#echo "Completed FDisk"
		#exit 0
	elif [[ x$MAQUINA =~ x[ncswbdt][0-9][0-9] ]]; then
		# greta prod is n00, d00 2 digits only
		echo "hostname pattern passes sanity test, continuting..." # ie not causing an abort/exit
	else
		echo "hostname pattern sanity test FAILED. NOT running fdisk!  Exiting."
		exit 007
	fi
	# normal return, allow caller to decide what to do next

}

############################################################
############################################################


run_fdisk_cmd_single()
{

	case "$1" in
		sda)
			SD_NAME="/dev/sda"
			;;
		ssd)
			SD_NAME="/dev/nvme0n1"
			;;
		*)
			echo "must specify one of sda or ssd.  exiting"
			exit 007
			;;
	esac


	echo "About to run_fdisk_cmd_single... (sleeping for 20, ctrl-c to abort)"
	echo "run_fdisk_cmd_single arg1 is $1"
	echo "run_fdisk_cmd_single SD_NAME is $SD_NAME"
	sleep 20
	echo "Running run_fdisk_cmd_single..."

	## disable hotplug in kernel so that it doesn't (randomly) complain about inconsistent state
	## https://access.redhat.com/solutions/1547313
	echo "" > /proc/sys/kernel/hotplug
	sleep 3

	VG_NAME="vg0"

	#use lvm syntax
	SWAP_SIZE="8G"
	TMP_SIZE="8G"
	LOCAL_SIZE="100%FREE"

	LVMROOT="/sbin"
	MKFS="/sbin/mkfs.ext4"

	/sbin/swapoff -L swap
	/bin/umount /local
	/bin/umount /tmp

	### I had this at top, may not need to do that again here.
	echo "" > /proc/sys/kernel/hotplug

	#### ####
	#### #### test added mostly cuz often cut-n-paste.  but be careful with the exit and not dd'ing another host!
	#### ####
	if [[ x"$SD_NAME" == x ]]; then 
		echo "SD_NAME disk dev path not defined, exiting" 
		exit -1
	fi

	#wipe the partition table (and then some)
	/bin/dd if=/dev/zero of=$SD_NAME bs=1024k count=10

	echo running pvcreate
	$LVMROOT/pvcreate $SD_NAME
	echo running vgcreate
	$LVMROOT/vgcreate $VG_NAME $SD_NAME
	echo running lvcreate for swap
	$LVMROOT/lvcreate -y -n swap -L $SWAP_SIZE $VG_NAME    # -y for yes, even more dangerous now! 
	echo running lvcreate for tmp
	$LVMROOT/lvcreate -y -n tmp -L $TMP_SIZE $VG_NAME
	echo running lvcreate for local
	$LVMROOT/lvcreate -y -n local -l $LOCAL_SIZE $VG_NAME

	###
	sync
	sleep 1

	umount /tmp
	/sbin/mkswap -L swap /dev/$VG_NAME/swap
	$MKFS -L tmp /dev/$VG_NAME/tmp
	$MKFS -L local /dev/$VG_NAME/local


	## tin addition 2017.0718,2018.0125
	umount /tmp
	mount /tmp
	chmod 1777 /tmp
	chmod 1777 /var/tmp ###
	swapon -a
	swapon -s
	df -h /tmp

	sleep 5 # n00 machines in greta didn't get these created... adding a sleep delay to see if it help

	## next 2 lines added 2021.1027
	mkdir /local/log
	ls -ld /var/log /local/log
	echo "Fdisk on single disk ends.  Should reboot after fdisk partition disk..."

	## tin addition 2022.0426  - cuz greta vnfs has /var/lib/docker -> /local/docker
	mkdir     /local/docker
	chmod 755 /local/docker
	ls -ld    /local/docker  /var/lib/docker
	mkdir     /local/rsyslog  # apparently new config in /etc/rsyslog.conf write here, no sym link in dir
	chmod 755 /local/rsyslog

	## tin addition 2021.1118
	mkdir /local/log/munge
	#chown munge:munge /local/log/munge
	chown 998:998      /local/log/munge           # munge user not defined in greta, so hard coding it :P
	ls -ld /var/log  # expect link to /local/log

}



########################################
########################################
#### "main" 
########################################
########################################
########################################

case "$1" in 
	sda)
		run_sanity_check  # if fail check, it cause an abort/exit
		run_fdisk_cmd_single sda
		;;
	ssd)
		run_sanity_check  # if fail check, it cause an abort/exit
		run_fdisk_cmd_single ssd
		;;
	mms)
		run_sanity_check  # if fail check, it cause an abort/exit
		echo use ./part_disks_mms.sh # external script (in PSG), later can merge into here... 
		;;
	3d)
		echo "not yet implemented, use HPCS_TOOLKIT/raid_part_disks.sh for now"
		;;
	*)
		echo "this script now need 1 param: sda|ssd|mms|3d"
		;;
esac

exit 0


