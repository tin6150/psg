#!/bin/sh

## script to fdisk sda of a node 
## when it is first installed (or when hd has been replaced)
## Originally by Bernard Li,
## slightly modified, as there seems to be some typo... -Tin 2017.0711
## last significant change 2017.0814
## primarity loc: tin-bb/blpriv/hpcs_toolkit
## secondary loc: psg/script/hpc/

## [root@n0014 ~]# sudo -u bernardl cat  /global/home/users/bernardl/part_disks.sh  > /root/part_disks.sh
##[root@n0014 ~]# cat !$
##cat /root/part_disks.sh

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

#wipe the partition table (and then some)
/bin/dd if=/dev/zero of=$SD_NAME bs=1024k count=10

echo running pvcreate
$LVMROOT/pvcreate $SD_NAME
echo running vgcreate
$LVMROOT/vgcreate $VG_NAME $SD_NAME
echo running lvcreate for swap
$LVMROOT/lvcreate -n swap -L $SWAP_SIZE $VG_NAME
echo running lvcreate for tmp
$LVMROOT/lvcreate -n tmp -L $TMP_SIZE $VG_NAME
echo running lvcreate for local
$LVMROOT/lvcreate -n local -l $LOCAL_SIZE $VG_NAME

umount /tmp
/sbin/mkswap -L swap /dev/$VG_NAME/swap
$MKFS -L tmp /dev/$VG_NAME/tmp
$MKFS -L local /dev/$VG_NAME/local


## tin addition 2017.0718,2018.0125
umount /tmp
mount /tmp
chmod 1777 /tmp
swapon -a
swapon -s
echo "Should reboot after fdisk partition disk..."

