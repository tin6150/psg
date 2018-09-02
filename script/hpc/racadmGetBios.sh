#!/bin/sh

# script to get Dell BIOS settings 
# really just "get" portion of racadmGetBios.sh

### *** NO NEED FOR THIS
### *** use record_bios_settings.sh 
###     but using this file on Dell largely archive the same result



## RacAdmCmd='singularity exec -B /var/run  /global/home/users/tin/sn-gh/dell_idracadm/dell_idracadm.img /opt/dell/srvadmin/sbin/racadm'

# capture all settings to file 
# used to want diff result file than record_bios_settings.sh, but don't remember why and now don't want it differnet
#BIOSOUT=/tmp/Bios.settings.out
#BIOSHIGHLIGHT=/tmp/Bios.settings.highlight
BIOSOUT=/tmp/bios.settings.out
BIOSHIGHLIGHT=/tmp/bios.settings.highlight

hostname > $BIOSOUT
date    >> $BIOSOUT
echo "" >> $BIOSOUT

BiosItemList=$(singularity exec -B /var/run    /global/home/users/tin/sn-gh/dell_idracadm/dell_idracadm.img /opt/dell/srvadmin/sbin/racadm get BIOS. | xargs)
for Item in $BiosItemList; do
        singularity exec -B /var/run    /global/home/users/tin/sn-gh/dell_idracadm/dell_idracadm.img /opt/dell/srvadmin/sbin/racadm  get BIOS.$Item 
done >> $BIOSOUT

cat $BIOSOUT | egrep '^n0|2018$|MemOpMode|SubNumaCluster|SysProfile|Turbo|NodeInterleave|LogicalProc|Virtual|CStates|Uncore|EnergyPerf|ProcC1E' | tee $BIOSHIGHLIGHT

chown tin $BIOSOUT $BIOSHIGHLIGHT

