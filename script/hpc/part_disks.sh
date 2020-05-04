#!/bin/sh


## script to fdisk sda of a node 
## when it is first installed (or when hd has been replaced)
## Originally by Bernard Li,
## slightly modified, as there seems to be some typo... -Tin 2017.0711
## last significant change 2018.0824 (added sanity check fn)
## 1st loc: psg/script/hpc/
## 2nd loc: tin-bb/blpriv/hpcs_toolkit

### slightly updated 2019.0916 
### from perceus:/global/home/groups/scs/disks/part_disks.sh 

## old way:
## [root@n0014 ~]# sudo -u bernardl cat  /global/home/users/bernardl/part_disks.sh  > /root/part_disks.sh
##[root@n0014 ~]# cat !$
##cat /root/part_disks.sh



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

	# can't get regex to work as expected yet
	if [[ x$MAQUINA =~ xn[0-9][0-9][0-9][0-9] ]]; then
		echo "hostname pattern passes sanity test, running fdisk"
		run_fdisk_cmd  # no () in bash fn call!
		echo "Completed FDisk"
		exit 0
	fi


	# if didn't call fdisk fn, then exit
	echo "hostname pattern sanity test FAILED. NOT running fdisk!  Exiting."
	exit 007

}

############################################################
############################################################


run_fdisk_cmd()
{

	## disable hotplug in kernel so that it doesn't (randomly) complain about inconsistent state
	## https://access.redhat.com/solutions/1547313
	echo "" > /proc/sys/kernel/hotplug
	sleep 3

	VG_NAME="vg0"
	SD_NAME="/dev/sda"

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
	echo "Should reboot after fdisk partition disk..."

}



########################################
########################################
#### "main" 
########################################
########################################
########################################

run_sanity_check  # and if pass, that will call run_fdisk_cmd


