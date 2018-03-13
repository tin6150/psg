#!/bin/bash 

# need to run this as root

BIOSOUT=/tmp/bios.settings.out
BIOSHIGHLIGHT=/tmp/bios.settings.highlight

hostname > $BIOSOUT
date 	>> $BIOSOUT
echo "" >> $BIOSOUT

## create test whether dell or supermicro, maybe from ipmitool fru list | grep ... 

## then run fn as desired

record_bios_settings_supermicro () {

	SUM=/global/scratch/tin/sw/sum/sum_2.0.0_Linux_x86_64/sum

	##$SUM -c GetCurrentBiosCfg  --file $BIOSOUT --overwrite
	## there is (probably a bug) a small different in output using --file vs > redirect of std out
	## * indicating default are different for a handful of entries.  
	## but actual query result reflect correct current bios settings
	$SUM -c GetCurrentBiosCfg  >> $BIOSOUT  

	cat $BIOSOUT | egrep --color '^n0|2018|Hyper-Threading|Turbo|CPU\ C\ State=|Cluster\ Mode=|Memory\ Mode=' | tee $BIOSHIGHLIGHT
} # end record_bios_settings_supermicro


record_bios_settings_dell () {

	BiosItemList=$(singularity exec -B /var/run    /global/home/users/tin/sn-gh/dell_idracadm/dell_idracadm.img /opt/dell/srvadmin/sbin/racadm get BIOS. | xargs)
	for Item in $BiosItemList; do
		singularity exec -B /var/run    /global/home/users/tin/sn-gh/dell_idracadm/dell_idracadm.img /opt/dell/srvadmin/sbin/racadm  get BIOS.$Item 
	done >> $BIOSOUT

	cat $BIOSOUT | egrep '^n0|2018$|MemOpMode|SubNumaCluster|SysProfile|Turbo|NodeInterleave|LogicalProc|Virtual|CStates|Uncore|EnergyPerf|ProcC1E' | tee $BIOSHIGHLIGHT
	#echo "----knl----" | tee -a $BIOSHIGHLIGHT
	cat $BIOSOUT | egrep 'ProcEmbMemMode|SystemMemoryModel|DynamicCoreAllocation|ProcConfigTdp' | tee -a $BIOSHIGHLIGHT

	# create a backup of sm bios file before turnning off HY for new cf1 nodes.
	MAQ=$(hostname)
	CentralLogRepo=/global/scratch/tin/gsCF_BK/cf1/sm_bios_cf
	#FECHA=$(date "+%Y-%m%d-%H%M")          # eg 2018-0304-0333
	FECHA=$(date "+%Y-%m%d")                # eg 2018-0304
	BiosBkDir=${CentralLogRepo}/bak${FECHA}
	mkdir ${BiosBkDir}
	cp -p $BIOSOUT  ${BioBkDir}/${MAQ}.bios.settings.out

} # end record_bios_settings_dell fn


#record_bios_settings_dell
record_bios_settings_supermicro

chown tin $BIOSOUT $BIOSHIGHLIGHT

