#!/bin/sh

# script to a job on each execution node, 
# useful to ensure all node accept job, 
# or to verify cluster wide changes has taken effect on every node. 
# if desired to run as root, copy script to fs w/ root write access
# 
# (sudo) ./SGE_run_on_every_node.sh 
# 
# wget https://raw.githubusercontent.com/tin6150/psg/master/script/hpc/SGE_run_on_every_node.sh


QSUB_OUT=/clscratch/bofh1/uge_out/`date +%m%d__%H`
[[ ! -d $QSUB_OUT ]] && mkdir -p $QSUB_OUT



EXECHOSTS=`qconf -sel`
#EXECHOSTS=`qconf -sel | grep compute`
#EXECHOSTS=`qconf -sel | egrep "4-6|4-9"`
 
for TARGETHOST in $EXECHOSTS; do
        # TARGETHOST eg: compute-4-10.cm.cluster, want only node number for compact name
        NODENUM=$( echo $TARGETHOST | awk -F. '{print $1}' | awk -F'-' '{print $2 "-" $3}' )
        #echo qsub -p 1024 -pe mpi $numprocs -q default.q@$TARGETHOST --exclusive=true
        #qsub -p 1024 -q admin.q@$TARGETHOST -l h_rt=600,m_mem_free=2G job4node.qsub
        qsub -N N-${NODENUM} -j y -o ${QSUB_OUT} -q admin.q@${TARGETHOST}  job4node.qsub   # run time and memory req specified n qsub script
done
