#!/bin/bash

## sync for bofh24, with zorin mounted under /mnt/zorin_rootFS

## run as root on both24, inside tmux "sync"
## bash -x rsync_zorin_bofh24.sh 2>&1 | tee rsync_zorin_bofh24.TEEOUT.2024.0716

## before final rsync, add --delete_flag
## things would be in .snapshot, but that provide a safe in case used flag wrong (not likely, not sure why i am so paranoid)

#   remember:
#              rsync -av /src/foo    /dest                  # **<<**
#              rsync -av /src/foo/   /dest/foo              
#              rsync -av /global/home/users/   /home/    

#              rsync -av /src/foo/   /dest/foo/ ???   recommended by jw/wf, works if destination foo/ already exist
# trying this eg on bofh to copy dir content but change the dir name, thus / in both src and dst
# rsync -vaurtxHD  --exclude=.snapshot  ~/mnt/brc-gs/guatemala_amr/assembled-sequences_sn/                              /mnt/scientific_home/tin/tin-git-SL/guatemala_amr/assembled-sequences_sn_MANUAL_DUP_5/   # ~4G expected


                  rsync -vaurtxHD /mnt/zorin_rootFS/home/tin/tin-gh       /home/tin
echo $?
date
                  rsync -vaurtxHD /mnt/zorin_rootFS/home/tin/tin-gh-alt   /home/tin
echo $?
date



