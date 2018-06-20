#!/bin/bash

### script to submit job to run hpl
### so that it can request proper node and run mpi
### xref ~/gsHPCS_toolkit/benchmark/hpl ^**>  less xrun_hpl_multi_node.sh

### bulk of the setting/work is in the job script hpl_mpi.job
### used to just do:
### sbatch hpl_mpi.job


#Clust=voltaire;         HplP=4;         HplQ=14;                
#Flag="--qos=normal --partition=voltaire --account=scs"; CORES=$(( $HplP * $HplQ ))


#echo DBG:: sbatch  $Flag -n ${CORES} --job-name=hplOn7nodes  $SlurmScript -c $Clust -P $HplP -Q $HplQ -o $OutDirBase 
#sbatch  $Flag -n ${CORES} --job-name=hplOn7nodes  $SlurmScript -c $Clust -P $HplP -Q $HplQ -o $OutDirBase 


#perceus-00|scs|tin|cf1-hp|1||||||||||||condo_mp|||
#perceus-00|scs|tin|cf1|1||||||||||||cf_debug,cf_normal|||
#brc|scs|tin|savio2_knl|1||||||||||||normal,savio_debug,savio_lowprio,savio_normal|||



#Flag="-N 8"
Flag="-N 16 --partition=cf1-hp     --qos=condo_mp"
Flag="-N  1 --partition=savio2_knl --qos=savio_normal" #               --reservation=Maint031218 "
Flag="-n 64 --partition=savio2_knl --qos=savio_normal" 
Flag="-n 64 --ntasks-per-node 64 --partition=savio2_knl --qos=savio_normal"   # still get dispatched to two nodes
Flag="-n 64 --ntasks-per-socket 64 --partition=savio2_knl --qos=savio_normal"   # still get dispatched to two nodes
Flag="-n 64 --ntasks-per-socket 64 --core-spec=1 --partition=savio2_knl --qos=savio_normal"   # still get dispatched to two nodes
Flag="-n 64 --ntasks-per-socket 64 --core-spec=2 --partition=savio2_knl --qos=savio_normal"   # still get dispatched to two nodes
#Flag="-N  2 --partition=savio2     --qos=savio_normal -J Sn_mpiTest --reservation=tin66 "
#Flag="-N 1"
#Flag=""



sbatch $Flag hpl_mpi.job


## tmp
squeue -u tin
