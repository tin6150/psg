#!/bin/bash

## sync from (usb) hd to /k

## run with sudo on bofh
## sudo ./rsync_hd_2_k.sh 2>&1 | tee -a rsync_hd_2_k.log

# 	remember:
#              rsync -av /src/foo    /dest
#              rsync -av /src/foo/   /dest/foo



#SRC_BASE=/media/tin/b3fb993c-ce42-4567-9174-601b314ed7fb/
#DST=/k/f # para fotos (mostly)

# /dev/sde3       457G  433G  1.6G 100% /media/tin/4f0a4454-a35c-4a2e-965f-7f728d813b99
SRC_BASE=/media/tin/4f0a4454-a35c-4a2e-965f-7f728d813b99/
DST=/k/1	# "tier 1 backup mostly"

# ran out of space on bofh, redo with an extra hd if avail...

[[ -d $DST ]] || mkdir -p $DST 


SRC_LIST="${SRC_LIST} ${SRC_BASE}"
for I in $SRC_LIST; do
	#rsync -aul $I $DST_B
	# -a =  -rlptgoD (no -H,-A,-X), not all of which avail for FAT
	# are these aerie/bsd flags?
	echo running: rsync -urltD $I $DST  
	rsync -urltD $I $DST  
	
	du -ks $I   | tee $DST/du-ks-src-$I.out
	du -k  $I   | tee $DST/du-k-src-$I.out
	du -ks $DST | tee $DST/du-ks-dst-$DST.out
	du -k  $DST | tee $DST/du-k-dst-$DST.out

done



