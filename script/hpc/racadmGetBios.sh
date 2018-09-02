#!/bin/sh

# script to get Dell BIOS settings 
# really just "get" portion of racadmGetBios.sh


## RacAdmCmd='singularity exec -B /var/run  /global/home/users/tin/sn-gh/dell_idracadm/dell_idracadm.img /opt/dell/srvadmin/sbin/racadm'

# capture all settings to file (from record_bios_settings.sh)
BIOSOUT=/tmp/Bios.settings.out
BIOSHIGHLIGHT=/tmp/Bios.settings.highlight

hostname > $BIOSOUT
date    >> $BIOSOUT
echo "" >> $BIOSOUT

BiosItemList=$(singularity exec -B /var/run    /global/home/users/tin/sn-gh/dell_idracadm/dell_idracadm.img /opt/dell/srvadmin/sbin/racadm get BIOS. | xargs)
for Item in $BiosItemList; do
        singularity exec -B /var/run    /global/home/users/tin/sn-gh/dell_idracadm/dell_idracadm.img /opt/dell/srvadmin/sbin/racadm  get BIOS.$Item 
done >> $BIOSOUT

cat $BIOSOUT | egrep '^n0|2018$|MemOpMode|SubNumaCluster|SysProfile|Turbo|NodeInterleave|LogicalProc|Virtual|CStates|Uncore|EnergyPerf|ProcC1E' | tee $BIOSHIGHLIGHT

chown tin $BIOSOUT $BIOSHIGHLIGHT

