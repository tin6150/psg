#!/bin/bash

# this is a wrapper script called from "sbatch ansys_job"
# to run ansys  from inside the Singularity container environment
# -Tin 2018.0105

# debug use
hostname
cat /etc/redhat-release
rpm -qa | grep release
id -a
pwd


export MODULEPATH=\
/global/software/sl-6.x86_64/modfiles/langs:\
/global/software/sl-6.x86_64/modfiles/tools:\
/global/software/sl-6.x86_64/modfiles/apps:\
/global/software/sl-6.x86_64/modfiles/intel/2016.4.072

# /global/home/groups-sw/ac_alsu/software/ansys/16.2/shared_files/lib

source /etc/profile.d/modules.sh

#module load tcltk
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/global/home/groups-sw/ac_alsu/software/ansys/16.2/shared_files/lib/linx64/


ldd /global/home/groups-sw/ac_alsu/software/ansys/16.2/v162/commonfiles/Tcl/bin/linx64/wish

/global/home/groups-sw/ac_alsu/software/ansys/16.2/v162/commonfiles/Tcl/bin/linx64/wish $@



