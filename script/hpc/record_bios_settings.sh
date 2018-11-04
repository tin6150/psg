#!/bin/bash 

# need to run this as root

# to make backup for all new sm knl nodes:
# run as root on perceus:
# pdsh -w n00[00-11,20-71].cf1 /global/home/users/tin/PSG/script/hpc/record_bios_settings.sh

# to make backup for all new sm gpu nodes in savio2:
# run as root on master.brc:
# pdsh -w n0[298-301].savio2 /global/home/users/tin/PSG/script/hpc/record_bios_settings.sh

# as tin, need to precreate
# mkdir -p /global/home/users/tin/CF_BK/pub/sm_bios_cf
# chmod 777 /global/home/users/tin/CF_BK/pub
# chmod 777 /global/home/users/tin/CF_BK/pub/sm_bios_cf
# bleh... do it in scratch where root can overwtite...

#CentralLogRepo=/global/home/users/tin/CF_BK/pub/sm_bios_cf
#CentralLogRepo=/global/home/users/tin/CF_BK/cf1/sm_bios_cf
#CentralLogRepo=/global/scratch/tin/gsCF_BK/cf1/sm_bios_cf
CentralLogRepo=/global/scratch/tin/gsCF_BK/savio2/sm_bios_cf
#FECHA=$(date "+%Y-%m%d-%H%M")          # eg 2018-0304-0333
FECHA=$(date "+%Y-%m%d")                # eg 2018-0304
BiosBkDir=${CentralLogRepo}/bak${FECHA}
test -d ${BiosBkDir} || mkdir ${BiosBkDir}


BIOSOUT=/tmp/bios.settings.out
BIOSHIGHLIGHT=/tmp/bios.settings.highlight

hostname > $BIOSOUT
date 	>> $BIOSOUT
echo "" >> $BIOSOUT

## create test whether dell or supermicro, maybe from ipmitool fru list | grep ... 

## then run fn as desired

record_bios_settings_supermicro () {

	SUM=/global/scratch/tin/sw/sum/sum_2.0.0_Linux_x86_64/sum
	#SUM=/global/home/users/tin/sw/sum/sum_2.0.0_Linux_x86_64/sum

	##$SUM -c GetCurrentBiosCfg  --file $BIOSOUT --overwrite
	## there is (probably a bug) a small different in output using --file vs > redirect of std out
	## * indicating default are different for a handful of entries.  
	## but actual query result reflect correct current bios settings
	$SUM -c GetCurrentBiosCfg  >> $BIOSOUT  

	#cat $BIOSOUT | egrep --color '^n0|2018|Hyper-Threading|Turbo|CPU\ C\ State=|Cluster\ Mode=|Memory\ Mode=' | tee $BIOSHIGHLIGHT

	# create a backup of sm bios file before turnning off HY for new cf1 nodes.
	MAQ=$(hostname)
	cp $BIOSOUT  ${BiosBkDir}/${MAQ}.bios.settings.out
	#ls -l       ${BiosBkDir}/${MAQ}.bios.settings.out

} # end record_bios_settings_supermicro


record_bios_settings_dell () {

	BiosItemList=$(singularity exec -B /var/run    /global/home/users/tin/sn-gh/dell_idracadm/dell_idracadm.img /opt/dell/srvadmin/sbin/racadm get BIOS. | xargs)
	for Item in $BiosItemList; do
		singularity exec -B /var/run    /global/home/users/tin/sn-gh/dell_idracadm/dell_idracadm.img /opt/dell/srvadmin/sbin/racadm  get BIOS.$Item 
	done >> $BIOSOUT

	cat $BIOSOUT | egrep '^n0|2018$|MemOpMode|SubNumaCluster|SysProfile|Turbo|NodeInterleave|LogicalProc|Virtual|CStates|Uncore|EnergyPerf|ProcC1E' | tee $BIOSHIGHLIGHT
	#echo "----knl----" | tee -a $BIOSHIGHLIGHT
	echo this is new file...
	cat $BIOSOUT | egrep 'ProcEmbMemMode|SystemMemoryModel|DynamicCoreAllocation|ProcConfigTdp' | tee -a $BIOSHIGHLIGHT
} # end record_bios_settings_dell fn


#record_bios_settings_dell
record_bios_settings_supermicro

chown tin $BIOSOUT $BIOSHIGHLIGHT

