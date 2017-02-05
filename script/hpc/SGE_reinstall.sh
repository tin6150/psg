#!/bin/sh

#$ -l=h+rt=600,m_mem_free=2G

# script to reboot each node, which trigger a PXE boot and a reinstall.
# run as root on fs w/ root write access
# ./SGE_reinstall.s

echo "Be sure script what is desired before really running it!!"
exit 007
 
ME=`hostname`
#EXECHOSTS=`qconf -sel`
EXECHOSTS=`qconf -sel | grep compute-3-1`
 
for TARGETHOST in $EXECHOSTS; do
        if [ "$ME" == "$TARGETHOST" ]; then
                echo "Skipping $ME. This is the submission host"
        else
                numprocs=`qconf -se $TARGETHOST | \
                        awk '/^processors/ {print $2}'`
                        # the processors line isn't optimal, as it may include hyperthreading if it is not disabled.
                        # m_core in the load_values section is more accurate, harder to parse out.
                # need to get exclusive configured as COMPLEX in each host and use that to best ensure no other job on node:
                echo qsub -p 1024 -pe mpi $numprocs -q default.q@$TARGETHOST --exclusive=1
                qsub -p 1024 -pe mpi $numprocs -q default.q@$TARGETHOST \
                        ./reboot.qsub
                echo "Set $TARGETHOST for Reinstallation"
        fi
done
