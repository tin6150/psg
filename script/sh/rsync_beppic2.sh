#!/bin/bash

## sync from old netapp to new

## run as root on beppic2, inside a screen session, so that ssh timeout doesn't kill rsync
## bash -x rsync_beppic2.sh 2>&1 | tee rsync_beppic2.TEEOUT

## before final rsync, add --delete_flag
## things would be in .snapshot, but that provide a safe in case used flag wrong (not likely, not sure why i am so paranoid)

#   remember:
#              rsync -av /src/foo    /dest                  # **<<**
#              rsync -av /src/foo/   /dest/foo              
#              rsync -av /global/home/users/   /home/    

#              rsync -av /src/foo/   /dest/foo/ ???   recommended by jw/wf, works if destination foo/ already exist
# trying this eg on bofh to copy dir content but change the dir name, thus / in both src and dst
# rsync -vaurtxHD  --exclude=.snapshot  ~/mnt/brc-gs/guatemala_amr/assembled-sequences_sn/                              /mnt/scientific_home/tin/tin-git-SL/guatemala_amr/assembled-sequences_sn_MANUAL_DUP_5/   # ~4G expected


#SRC_BASE=/

SRC_LIST="${SRC_BASE}/home"
SRC_LIST="$SRC_LIST  ${SRC_BASE}/eda"
SRC_LIST="$SRC_LIST  ${SRC_BASE}/global/oldhome"

# /global/scratch  ??

DST=/mnt/beppic-filer2

#-- [[ -d $DST ]] || mkdir -p $DST 
#x[[ -d $DST/home ]] || mkdir -p $DST/home
#x[[ -d $DST/eda ]] || mkdir -p $DST/eda

date | tee -a rsync_script_start.flag

for I in $SRC_LIST; do
    date | tee -a rsync_loop_start.flag
    #rsync -aul $I $DST_B
    # -a =  -rlptgoD (no -H,-A,-X), not all of which avail for FAT
    # are these aerie/bsd flags?
    echo running: rsync -vaurtxHD --delete-after --exclude='.snapshot' $I $DST  
                  rsync -vaurtxHD --delete-after --exclude='.snapshot' $I $DST  
    echo "================="
    echo $?  | tee -a rsync_loop_start.flag
    date | tee -a rsync_loop_ends.flag
    
#   du -ks $I   | tee $DST/du-ks-src-$I.out
#   du -k  $I   | tee $DST/du-k-src-$I.out
#   du -ks $DST | tee $DST/du-ks-dst-$DST.out
#   du -k  $DST | tee $DST/du-k-dst-$DST.out

done


date | tee -a rsync_script_end.flag

