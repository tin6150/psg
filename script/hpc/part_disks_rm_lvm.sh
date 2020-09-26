#!/bin/sh

#### part of troubleshooting 6 TiB NetApp drive
#### remove all lvm, so that can try to redo...
#### not fully tested


## script to fdisk sda of a node 
## when it is first installed (or when hd has been replaced)



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
		run_rm_lvm_cmd  # no () in bash fn call!
		echo "Completed FDisk"
		exit 0
	fi


	# if didn't call fdisk fn, then exit
	echo "hostname pattern sanity test FAILED. NOT running fdisk!  Exiting."
	exit 007

}

############################################################
############################################################


run_rm_lvm_cmd()
{

	## disable hotplug in kernel so that it doesn't (randomly) complain about inconsistent state
	## https://access.redhat.com/solutions/1547313
	echo "" > /proc/sys/kernel/hotplug
	sleep 3

	VG_NAME="vg0"
	SD_NAME="/dev/sda"

	LVMROOT="/sbin"
	MKFS="/sbin/mkfs.ext4"

	/sbin/swapoff -L swap
	/bin/umount /local
	/bin/umount /tmp

	### I had this at top, may not need to do that again here.
	echo "" > /proc/sys/kernel/hotplug



	echo undo lvcreate for swap
	$LVMROOT/lvremove  /dev/${VG_NAME}/tmp
	$LVMROOT/lvremove  /dev/${VG_NAME}/local
	$LVMROOT/lvremove  /dev/${VG_NAME}/swap

	echo undo vgcreate
	$LVMROOT/vgremove $VG_NAME $SD_NAME

	echo undo pvcreate
	$LVMROOT/pvremove $SD_NAME

	#wipe the partition table (and then some)
	/bin/dd if=/dev/zero of=$SD_NAME bs=1024k count=10


	###
	sync
	sleep 1



	## tin 
	swapon -a
	swapon -s
	df -h /tmp
	df -h /local


	dd if=/dev/zero of=/dev/sda  bs=1024k count=9000  # 9.4 GB
	dd if=/dev/zero of=/dev/sda  bs=1024k count=6M  # 6TB? 
}



########################################
########################################
#### "main" 
########################################
########################################
########################################

run_sanity_check  # and if pass, that will call run_rm_lvm_cmd


