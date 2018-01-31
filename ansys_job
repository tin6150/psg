#!/bin/bash
# Job name:
#SBATCH --job-name=AnsysSingularityTest
#
# Partition:
#SBATCH --partition=lr5
#
# Processors:
#SBATCH --nodes=1
#
# Wall clock limit:
#SBATCH --time=30:30:00
#
# QoS:
#SBATCH --qos=lr_normal
#
# Account:
#SBATCH --account=scs
#

## example slurm job script to launch Ansys in a SL6/CentOS6 enviroment.
## Utilizes Modules from a centralized location
## submit job as:
## sbatch ansys_job

#cd $SLURM_SUBMIT_DIR

# need to be in group ac_alsu
# cd /global/home/groups-sw/ac_alsu/software/ansys/16.2/v162/
# ./commonfiles/Tcl/bin/linx64/wish

AnsysCmd='singularity exec  -B /global/home/groups-sw,/global/software/sl-6.x86_64,/global/scratch /global/scratch/tin/singularity-repo/sl6_lbl.envMod+ipmi.simg /global/scratch/tin/singularity-repo/ansys.helper.sh'

$AnsysCmd  input.testfile

# sl6_lbl.envMod+ipmi.simg has openmotif libs
# openmotif-2.3.3-9.el6.x86_64
# openmotif22-2.2.3-19.el6.x86_64
 
# ht_helper may need more wrapping... 
