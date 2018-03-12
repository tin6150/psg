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


#Flag="-N 8"
Flag="-N 1"
Flag="-N 16 --partition=cf1-hp --qos=condo_mp"


sbatch $Flag hpl_mpi.job


## tmp
squeue -u tin
