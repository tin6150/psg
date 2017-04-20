#!/bin/sh


## in aerie...
## run as root!
## place in bg... then just check status with ps | grep rsync
## ash -x ./rsync_aerie_2_usbHd4safe.ash >  rsync_aerie_2_usbHd4safe.2013.0416.log 2>&1 &  # desktop hd
## ash -x ./rsync_aerie_2_usbHd4safe.ash >> rsync_aerie_2_usbHd4safe.2017.0417_4.log 2>&1 &  # laptop hd 


SRC_BASE_B=/run/media/sn/2181d607-bb9d-47a0-b39f-f04b821b2d1c/aerieBk20170417/NEED_OFFSITE_3b_rafa



SRC_B_LIST="${SRC_BASE_B}/rafa-lacie2010.1013"
SRC_B_LIST="${SRC_B_LIST} ${SRC_BASE_B}/rafa.backup4rafa.2011.0526"
SRC_B_LIST="${SRC_B_LIST} ${SRC_BASE_B}/rafa.backup4rafa.2011.0526b"
SRC_B_LIST="${SRC_B_LIST} ${SRC_BASE_B}/rafa-doc-2015"



DST_B=/run/media/sn/4D05-24E0

for I in $SRC_B_LIST; do
	rsync -aul $I $DST_B
done


#              rsync -av /src/foo    /dest
#              rsync -av /src/foo/   /dest/foo

