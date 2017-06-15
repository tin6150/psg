#!/bin/sh

#  https://tin6150.github.io/psg/sol.html#svm_cf

#BKDIR=/export/cfbk
BKDIR=/var/adm/cfbk

test -d $BKDIR || mkdir $BKDIR

cp -p /etc/vfstab 	$BKDIR
cp -p /etc/system	$BKDIR

cp -p /kernel/drv/md.conf $BKDIR
cp -p /etc/lvm/md.cf 	$BKDIR
cp -p /etc/lvm/mddb.cf	$BKDIR
cp -p /etc/lvm/md.tab	$BKDIR		# really manual file, metastat -p

metastat -p > $BKDIR/`date +%Y%m%d`.metastat-p
metastat    > $BKDIR/`date +%Y%m%d`.metastat

DISKPATH=/dev/rdsk/
DISKSET=`cd $DISKPATH; ls *s2`
#DISKSET="c0t0d0s2 c0t8d0s2 c0t9d0s2 c0t10d0s2" 
#DISKSET="c0t0d0s2 c0t8d0s2 c0t9d0s2 c0t10d0s2 c0t11d0s2 c0t12d0s2"
for DISK in $DISKSET; do
	prtvtoc $DISKPATH/$DISK > $BKDIR/`date +%Y%m%d`.vtoc."$DISK"
done

#eepromp param (alias for booting, if setup)
eeprom nvram 	> $BKDIR/`date +%Y%m%d`.eeprom.nvramrc.out
eeprom 		> $BKDIR/`date +%Y%m%d`.eeprom.out

