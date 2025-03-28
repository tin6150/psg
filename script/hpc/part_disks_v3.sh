#!/bin/sh
#vim: list nu background=dark


## script to fdisk sda, nvme0 of a node 
## when it is first installed (or when hd has been replaced)
## v3 has option to do mirror when two disks are present
##
## Originally by Bernard Li,
## slightly modified, as there seems to be some typo... -Tin 2017.0711
## last significant change 2018.0824 (added sanity check fn)
## 1st loc: psg/script/hpc/
## 2nd loc: tin-bb/blpriv/hpcs_toolkit

### update log (future)
### 2022.1010  SWAP=1024 cuz some bioinfo apps need it (OOM kicks in)
### 2023.0816  SWAP=512  TMP=64  n0113..137.sav4  due to typo
### 2024.0213  SWAP=64   TMP=120 + /local/scratch

#### 2022.0427
#### run as, single disk config:
#### ./part_disks_v3.sh sda       # single sda, traditional setup.  # n0001.hep0 
#### ./part_disks_v3.sh ssd       # single /dev/nvme0n1, rest is same setup as sda   n0122.savio4
#### sudo pdsh -w n0[258-261].savio3 ls -l ~tin/PSG/script/hpc/part_disks_v3.sh
#### sudo pdsh -w n0[187-190].savio4 ls -l ~tin/PSG/script/hpc/part_disks_v3.sh
####
#### run as, two disks mirror config:
#### ./part_disks_v3.sh nvme0+1   # mirror on /dev/nvme0n1 nvme1n1
#### ./part_disks_v3.sh sda+b     # mirror on sda sdb # untested
####

#### the 2 mirror + 1 single disk, "mms", see separate script part_disks_mms.sh , if still need to use it.


############################################################
# sanity check make sure running fdisk on expected machine (ie nodes)
############################################################

run_sanity_check() 
{

	MAQUINA=$(hostname -s)
	if [[ x$MAQUINA == x"perceus-00" ]]; then
		echo "DO NOT run here!"
		exit 007
	fi
        if [[ x$MAQUINA == x"master" ]]; then
                echo "DO NOT run here!"
                exit 007
        fi
        if [[ x$MAQUINA == x"beagle" ]] || [[ x$MAQUINA  == x"wwulf-master" ]]; then
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


## retest on n00? or b00?
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

        echo "run_fdisk_cmd_single arg1 is $1"
        echo "run_fdisk_cmd_single SD_NAME is $SD_NAME"
        echo "About to run_fdisk_cmd_single... (sleeping for 21, ctrl-c to abort)"
        sleep 21
        echo "Running run_fdisk_cmd_single..."

        ## disable hotplug in kernel so that it doesn't (randomly) complain about inconsistent state
        ## https://access.redhat.com/solutions/1547313
        echo "" > /proc/sys/kernel/hotplug
        sleep 3

	/sbin/swapoff -L swap
	/bin/umount /local
	/bin/umount /tmp

	### I had this at top, may not need to do that again here.
	echo "" > /proc/sys/kernel/hotplug

        #wipe the partition table (and then some)
        /bin/dd if=/dev/zero of=$SD_NAME bs=1024k count=10

	#### ####
	#### #### test added mostly cuz often cut-n-paste.  but be careful with the exit and not dd'ing another host!
	#### ####
	if [[ x"$SD_NAME" == x ]]; then 
		echo "SD_NAME disk dev path not defined, exiting" 
		exit -1
	fi


	echo running pvcreate
	$PVCREATE $SD_NAME
	echo running vgcreate
	$VGCREATE $VG_NAME $SD_NAME

	echo running lvcreate for swap
	$LVCREATE -y -n swap  $SWAP_SIZE $VG_NAME    # -y for yes, even more dangerous now! 
	echo running lvcreate for tmp
	$LVCREATE -y -n tmp   $TMP_SIZE $VG_NAME
	echo running lvcreate for local
	$LVCREATE -y -n local $LOCAL_SIZE $VG_NAME

	###
	sync
	sleep 1

} # end of run_fdisk_cmd_single

## test on s00
run_fdisk_cmd_mirror()
{
	## could add a check to be sure there are at least 2 args, but internal fn... lazy :P
	# find 1st disk for the mirror
	case "$1" in
		sda)
			D0_NAME="/dev/sda"
			;;
		nvme0)
			D0_NAME="/dev/nvme0n1"
			;;
		*)
			echo "must specify one of sda or nvme0 as first disk.  exiting"
			exit 007
			;;
	esac
	# find 2nd disk for the mirror
	case "$2" in
		sdb)
			D1_NAME="/dev/sdb"
			;;
		nvme1)
			D1_NAME="/dev/nvme1n1"
			;;
		*)
			echo "must specify one of sdb or nvme1 as second disk.  exiting"
			exit 007
			;;
	esac

	echo "run_fdisk_cmd_mirror arg1, arg2 are $1 $2"
	echo "run_fdisk_cmd_mirror on DiskX_NAMEs of $D0_NAME $D1_NAME"
	echo "About to run_fdisk_cmd_mirror... (sleeping for 22, ctrl-c to abort)"
	sleep 22
	echo "Running run_fdisk_cmd_mirror..."

	## disable hotplug in kernel so that it doesn't (randomly) complain about inconsistent state
	## https://access.redhat.com/solutions/1547313
	echo "" > /proc/sys/kernel/hotplug
	sleep 3

        /sbin/swapoff -L swap
        /bin/umount /local
        /bin/umount /tmp

	### I had this at top, may not need to do that again here.
	echo "" > /proc/sys/kernel/hotplug

        #wipe the partition table (and then some)
        /bin/dd if=/dev/zero of=$D0_NAME bs=1024k count=10
        /bin/dd if=/dev/zero of=$D1_NAME bs=1024k count=10

	if [[ x"$D0_NAME" == x ]] || [[ x"$D1_NAME" == x ]]; then 
		echo "D1_NAME disk dev path not defined, exiting" 
		exit -1
	fi

        echo running pvcreate
        $PVCREATE $D0_NAME $D1_NAME
        echo running vgcreate
        $VGCREATE $VG_NAME $D0_NAME $D1_NAME

        echo running lvcreate for swap
        $LVCREATE -y -n swap  $SWAP_SIZE  -m1 $VG_NAME    # -y for yes, even more dangerous now!
        # need to add -m1 to be mirror...
        echo running lvcreate for tmp
        $LVCREATE -y -n tmp   $TMP_SIZE   -m1 $VG_NAME
        echo running lvcreate for local
        $LVCREATE -y -n local $LOCAL_SIZE -m1 $VG_NAME
        #LOCAL_SIZE expect "+100%FREE" , which need to use lower case -l :-\

	###
	sync
	sleep 1
} # end of run_fdisk_cmd_mirror

#### this is for dev use
#### list of comands to undo the LVM creation, 
#### so as to be able to run this script again
rm_lvm_cf()
{
	swapoff -a
	umount /local
	umount /tmp
	lvremove /dev/VGmain/swap
	lvremove /dev/VGmain/local
	lvremove /dev/VGmain/tmp
	vgremove  VGmain
	# pvcreate won't complain when recreated on top of old one it seems

}


make_filesystem()
{
	# make filesystems 
	# using ext4 so that can shrink them,  xfs still not shrinkable
	sync
	sleep 1

	umount /tmp
	#swapoff 
	/sbin/mkswap -L swap  /dev/$VG_NAME/swap
	swapon -a
	swapon -s

	$MKFS        -L tmp   /dev/$VG_NAME/tmp
	$MKFS        -L local /dev/$VG_NAME/local

	## tin addition 2017.0718,2018.0125
	umount /tmp
	mount  /tmp
	chmod 1777 /tmp
	chmod 1777 /var/tmp ###
	df -h /tmp
}

make_dir_tree()
{
	sleep 5 # n00 machines in greta didn't get these created... adding a sleep delay to see if it help

	## next 2 lines added 2021.1027
	mkdir /local/log
	ls -ld /var/log /local/log 
	#-- ls -ld /var/log  # expect link to /local/log  (hmm... never did link, there are stuff in /var/log)  
	echo "Fdisk on single disk ends.  Should reboot after fdisk partition disk..."

	## tin addition 2022.0426  - cuz greta vnfs has /var/lib/docker -> /local/docker
	mkdir     /local/docker
	chmod 755 /local/docker
	ln -s     /local/docker  /var/lib/docker
	ls -ld    /local/docker  /var/lib/docker
	mkdir     /local/rsyslog  # apparently new config in /etc/rsyslog.conf write here, no sym link in dir
	chmod 755 /local/rsyslog
	mkdir     /local/scratch  # added 2024.0205 in updated  fstab-base-sl7-ciscat
	chmod 777 /local/scratch
	#chmod 1777 /local/scratch

	## tin addition 2021.1118
	mkdir /local/log/munge
	#chown munge:munge /local/log/munge
	chown 998:998      /local/log/munge           # munge user not defined in greta, so hard coding it :P

}




########################################
########################################
#### "main" 
########################################
########################################
########################################

# ++ parameters for partitions, tweak as desired
#    essentially global vars used by run_fdisk_* functions
# use lvm syntax
#SWAP_SIZE="-L 8G"
SWAP_SIZE="-L 64G"
#SWAP_SIZE="-L 512G" # 2T NVME that was never used swap may wear drive anyway, lager size spread wear...
#xx SWAP_SIZE="-L 1024G"   ## ?? largeSwap as feature ++CHANGEME++
#TMP_SIZE="-L 8G"
#TMP_SIZE="-L 64G"
TMP_SIZE="-L 120G"
LOCAL_SIZE="-l 100%FREE"  # % format need -l, thus embedding the flag as part of the argument

#### don't expect to have to change these
VG_NAME="VGmain"
VGCREATE="/sbin/vgcreate"
PVCREATE="/sbin/pvcreate"
LVMROOT="/sbin"               # old single disk portion still using this old code
LVCREATE="/sbin/lvcreate"
MKFS="/sbin/mkfs.ext4"


case "$1" in 
	sda)
		run_sanity_check  # if fail check, it cause an abort/exit
		run_fdisk_cmd_single sda
		make_filesystem
		make_dir_tree
		;;
	ssd)
		run_sanity_check  # if fail check, it cause an abort/exit
		run_fdisk_cmd_single ssd
		make_filesystem
		make_dir_tree
		;;
	nvme0+1)
		run_sanity_check  # if fail check, it cause an abort/exit
		#-- echo use ./part_disks_mms.sh # external script (in PSG), later can merge into here... 
		run_fdisk_cmd_mirror nvme0 nvme1
		make_filesystem
		make_dir_tree
		;;
	sda+b)
		run_sanity_check  # if fail check, it cause an abort/exit
		run_fdisk_cmd_mirror sda sdb
		make_filesystem
		make_dir_tree
		;;
	mms)
		echo use ./part_disks_mms.sh # external script (in PSG), later can merge into here... 
		# or maybe merge now
		;;
	3d)
		echo "not yet implemented, use HPCS_TOOLKIT/raid_part_disks.sh for now"
		;;
	*)
		echo "this script now need 1 param: sda|ssd|nvme0+1|sda+b"
		;;
esac

exit 0


#vim: list nu background=dark
