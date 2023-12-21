#!/bin/bash

## sync from old netapp to new

## run as root on beppic2
## bash -x rsync_beppic2.sh 2>&1 | tee rsync_beppic2.TEEOUT

# 	remember:
#              rsync -av /src/foo    /dest					# **<<**
#              rsync -av /src/foo/   /dest/foo				
#              rsync -av /global/home/users/   /home/    

#              rsync -av /src/foo/   /dest/foo/ ???   recommended by jw/wf, works if destination foo/ already exist
# trying this eg on bofh to copy dir content but change the dir name, thus / in both src and dst
# rsync -vaurtxHD  --exclude=.snapshot  ~/mnt/brc-gs/guatemala_amr/assembled-sequences_sn/                              /mnt/scientific_home/tin/tin-git-SL/guatemala_amr/assembled-sequences_sn_MANUAL_DUP_5/   # ~4G expected



SRC_LIST="${SRC_BASE}/home"
SRC_LIST="$SRC_LIST  ${SRC_BASE}/eda"
#SRC_LIST="${SRC_BASE}/global/oldhome"

# /global/scratch  ??

DST=/mnt/beppic-filer2

#-- [[ -d $DST ]] || mkdir -p $DST 
#x[[ -d $DST/home ]] || mkdir -p $DST/home
#x[[ -d $DST/eda ]] || mkdir -p $DST/eda


for I in $SRC_LIST; do
	#rsync -aul $I $DST_B
	# -a =  -rlptgoD (no -H,-A,-X), not all of which avail for FAT
	# are these aerie/bsd flags?
	echo running: rsync -vaurtxHD --exclude='.snapshot' $I $DST  
	#echo running: rsync -vaurtxHD --exclude='.snapshot' $I $DST  
	
#	du -ks $I   | tee $DST/du-ks-src-$I.out
#	du -k  $I   | tee $DST/du-k-src-$I.out
#	du -ks $DST | tee $DST/du-ks-dst-$DST.out
#	du -k  $DST | tee $DST/du-k-dst-$DST.out

done



#####

# for old-scratch, jw recommended:
# rsync -axHP /global/scratch-old/$USER/ /global/scratch/$USER/
#         -a, --archive               archive mode; equals -rlptgoD (no -H,-A,-X)
#         -x, --one-file-system       don't cross filesystem boundaries
#         -H, --hard-links            preserve hard links
#         -P                          same as --partial --progress

# didn't have:
#         -u, --update                skip files that are newer on the receiver
#         -l, --links                 copy symlinks as symlinks (actually part of -a)





