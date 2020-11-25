#!/bin/sh


## script to fdisk sda of a node 
## when it is first installed (or when hd has been replaced)
## Originally by Bernard Li,
## slightly modified, as there seems to be some typo... -Tin 2017.0711
## last significant change 2018.0824 (added sanity check fn)

## TBD loc: psg/script/hpc/
## 2nd loc: tin-bb/blpriv/hpcs_toolkit

#### this version offset where partition start
#### leave out first 32 GB where swap/tmp was, probably got lots of wear in those spot
#### but disk may last a bit longer if only use the rest of the space 
#### use parted instead of fdisk.  no lvm to control where space allocated.
#### 2020.11.24




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
		##run_fdisk_cmd  # no () in bash fn call!
		run_clearing_cmd  # no () in bash fn call!
		run_parted_cmd  # no () in bash fn call!
		echo "Completed FDisk"
		exit 0
	fi


	# if didn't call fdisk fn, then exit
	echo "hostname pattern sanity test FAILED. NOT running fdisk!  Exiting."
	exit 007

}

############################################################
############################################################

SD_NAME="/dev/sda"
MKFS="/sbin/mkfs.ext4"

run_clearing_cmd()
{
	/bin/umount /local
	/bin/umount /tmp
	/sbin/swapoff -L swap
	/bin/dd if=/dev/zero of=$SD_NAME bs=1024k count=10

	# lvremove?
}

run_parted_cmd()
{
	## disable hotplug in kernel so that it doesn't (randomly) complain about inconsistent state
	## https://access.redhat.com/solutions/1547313
	echo "" > /proc/sys/kernel/hotplug
	sleep 3

	#parted $SD_NAME mklabel gpt		# wipe fdisk partition config
	parted $SD_NAME mklabel  msdos		# mbr partition table
	# 1953525167 sectors for 1000.2 GB hd
	# nhc swap max: 8388608 kB # 8 GiB  GiB is multiple of 1024
	# nhc swap min: 7340032 kB # 7 GiB
	parted $SD_NAME mkpart primary linux-swap 32GiB 40GiB # type id 82 
	parted $SD_NAME mkpart primary ext2 40GiB 52GiB       # type id 83
	parted $SD_NAME mkpart primary ext2 52GiB 98%
	parted $SD_NAME align-check optimal 1
	parted $SD_NAME align-check optimal 2
	parted $SD_NAME align-check optimal 3


	/sbin/mkswap -L swap ${SD_NAME}1
	$MKFS -L tmp         ${SD_NAME}2
	$MKFS -L local       ${SD_NAME}3

	## tin addition 2017.0718,2018.0125
	umount /tmp
	mount /tmp
	chmod 1777 /tmp
	chmod 1777 /local
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


