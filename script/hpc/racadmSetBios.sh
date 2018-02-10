#!/bin/sh

# script to make BIOS settings to desired HPL optmized settings
# this version is for skylake cpu on Dell C6420 circa 2018.02


RacAdmCmd='singularity exec -B /var/run  /global/home/users/tin/sn-gh/dell_idracadm/dell_idracadm.img /opt/dell/srvadmin/sbin/racadm'

#$RacAdmCmd 
$RacAdmCmd set BIOS.ProcSettings.LogicalProc      Disabled
$RacAdmCmd set BIOS.MemSettings.MemOpMode         OptimizerMode  # default, should not need to change this for HPC
$RacAdmCmd set BIOS.MemSettings.NodeInterleave    Disabled 	 # default, not compatible with SubNumaCluster, not typically recommended
$RacAdmCmd set BIOS.ProcSettings.SubNumaCluster   Enabled        # Disabled is default, only useful if app can better utlize localized mem
#$RacAdmCmd set BIOS.SysProfileSettings.SysProfile PerfOptimized  # default
#$RacAdmCmd set BIOS.SysProfileSettings.SysProfile PerfPerWattOptimizedDapc       # said to save energy
#$RacAdmCmd set BIOS.SysProfileSettings.SysProfile PerfPerWattOptimizedOs         # may save energy, seems to introduce clock/timing bug
$RacAdmCmd set BIOS.SysProfileSettings.SysProfile Custom
## >> tweak >>
$RacAdmCmd set BIOS.ProcSettings.ControlledTurbo  Enabled        # allow for external control of when to engage turbo?  Def: Disabled.
$RacAdmCmd set BIOS.SysProfileSettings.ProcTurboMode  Enabled    # read-only unless in custom profile, def=Enabled. 
$RacAdmCmd set BIOS.SysProfileSettings.ProcCStates Autonomous    # def: Disabled. alt: Enabled # to allow proc to operate in all avail power state
$RacAdmCmd set BIOS.SysProfileSettings.UncoreFrequency DynamicUFS        # def: MaxUFS
      # https://software.intel.com/en-us/forums/software-tuning-performance-optimization-platform-monitoring/topic/543513

# things that got changed when switched to Custom SysProfile and thus need setting again:
## >> tweak >>
$RacAdmCmd set BIOS.SysProfileSettings.ProcC1E Disabled           # def: Disabled  # but enabled when switch to Custom SysProfile !!
                                                                  # Enable = processor is allowed to switch to minimum performance state when idle.
$RacAdmCmd set BIOS.SysProfileSettings.EnergyPerformanceBias MaxPower   # def (ie Performance).  
                                                        		# alt: BalancedPerformance, BalancedEfficiency, LowPower

$RacAdmCmd set BIOS.SysProfileSettings.CpuInterconnectBusLinkPower Disabled	# PerfOptimized SysProfile had this as Disabled, Custom changed to Enabled
$RacAdmCmd set BIOS.SysProfileSettings.PcieAspmL1 Disabled	# PerfOptimized SysProfile had this as Enabled, Custom changed to Disabled
$RacAdmCmd set BIOS.SysProfileSettings.ProcPwrPerf MaxPerf      # PerfOptimized SysProfile had this as SysDbpm, Custom changed to Disabled

#$RacAdmCmd set BIOS.SysProfileSettings.DynamicCoreAllocation Disabled # not changed

# hard coding these just in case Custom SysProfile or other changes it

$RacAdmCmd set BIOS.SysProfileSettings.MemFrequency  MaxPerf            # def: MaxPerf.  Could choose diff speed such as 2666 MHz, 2400, 1866.
#$RacAdmCmd set BIOS.SysProfileSettings.WriteDataCrc  Disabled		# still same
#$RacAdmCmd get BIOS.SysProfileSettings.MemPatrolScrub Standard		# still same
#$RacAdmCmd get BIOS.SysProfileSettings.MemRefreshRate 1x     		# still same
  #get BIOS.ProcSettings.UpiPrefetch                     # def: Enabled
  #get BIOS.MemSettings.OppSrefEn                        # def: Disabled 
  #get BIOS.MemSettings.CorrEccSmi Enabled	# hope this is not enabling ECC


$RacAdmCmd jobqueue create BIOS.Setup.1-1 
$RacAdmCmd jobqueue view


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


# use either of the cmd below to power cycle
# $RacAdmCmd serveraction powercycle 
# singularity exec -B /var/run  /global/home/users/tin/sn-gh/dell_idracadm/dell_idracadm.img /opt/dell/srvadmin/sbin/racadm  serveraction powercycle 
# ipmitool power cycle   # is this right?

