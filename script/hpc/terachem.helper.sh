#!/bin/bash

# this is a wrapper script called from "sbatch terachem_job"
# to run TeraChem from inside the Singularity container environment
# -Tin 2018.0104

# debug use
#hostname
#id -a
#pwd


export MODULEPATH=\
/global/software/sl-6.x86_64/modfiles/langs:\
/global/software/sl-6.x86_64/modfiles/tools:\
/global/software/sl-6.x86_64/modfiles/apps:\
/global/home/groups-sw/nano/modulefiles/sl-6.x86_64:\
/global/software/sl-6.x86_64/modfiles/intel/2016.4.072

source /etc/profile.d/modules.sh

module load cuda/8.0

source /global/home/groups-sw/nano/software/sl-6.x86_64/TeraChem/tcv1.91-stable/SetTCVars.sh

/global/home/groups-sw/nano/software/sl-6.x86_64/TeraChem/tcv1.91-stable/bin/terachem $@

