#!/bin/sh

## script to fdisk a node with 3 ssd (sda:240g, sdb:240g, sdc:1900g) eg n0143.savio3 colfax gpu node
## Run script when node is first installed (or when hd has been replaced)
## Originally by Bernard Li,
## slightly modified, as there seems to be some typo... -Tin 2017.0711
## This version from John that LVM mirror sda,sdb.  adapte on 2019.1204
## 1st loc: psg/script/hpc/
## 2nd loc: tin-bb/blpriv/hpcs_toolkit (TBD, since don't tend to run from that location)

## eg run
## pdsh -w n0145.savio3 ~tin/PSG/script/hpc/part_disks_3ssd.sh

## note that fstab should add "discard" clause for volume mounted on ssd (TRIM).
## lvm.conf should use issue_discards = 1

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

	if [[ x$MAQUINA == "master.brc.berkeley.edu" ]]; then
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
	echo "Hit ^C in 15s to cancel disk partitioning!"
	sleep 15

	## VG_NAME="vg0"
	## SD_NAME="/dev/sda"

	# strings are lvm syntax
	SWAP_SIZE="8G"
	#TMP_SIZE="8G"
	LOCAL_SIZE="100%FREE"

	LVMROOT="/sbin"
	MKFS="/sbin/mkfs.ext4"

	/sbin/swapoff -L swap
	/bin/umount /local
	/bin/umount /tmp

	### I had this at top, may not need to do that again here.
	echo "" > /proc/sys/kernel/hotplug

	#wipe the partition table (and then some)
	/bin/dd if=/dev/zero of=/dev/sda bs=1024k count=10
	/bin/dd if=/dev/zero of=/dev/sdb bs=1024k count=10
	/bin/dd if=/dev/zero of=/dev/sdc bs=1024k count=10

	echo running pvcreate
	$LVMROOT/pvcreate /dev/sda /dev/sdb /dev/sdc
	echo running vgcreate
	$LVMROOT/vgcreate mirror /dev/sda /dev/sdb
	$LVMROOT/vgcreate ssd    /dev/sdc
	echo running lvcreate for swap
	$LVMROOT/lvcreate -y -n swap -L $SWAP_SIZE -m1 mirror    # -y for yes, even more dangerous now! 
	# need to add -m1 to be mirror...
	echo running lvcreate for tmp
	$LVMROOT/lvcreate -y -n tmp -l +100%FREE -m1 mirror
	echo running lvcreate for local
	$LVMROOT/lvcreate -y -n local -l $LOCAL_SIZE ssd

	###
	sync
	sleep 1

	umount /tmp
	/sbin/mkswap -L swap /dev/mirror/swap
	$MKFS -L tmp /dev/mirror/tmp
	$MKFS -L local /dev/ssd/local


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


