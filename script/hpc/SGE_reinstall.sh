#!/bin/sh

# script to reboot each node, which trigger a PXE boot and a reinstall.
# run as root on fs w/ root write access
# ./SGE_reinstall.s
# wget https://tin6150.github.io/psg/script/hpc/SGE_reinstall.sh


## fool trap
echo "Be sure script what is desired before really running it!!"
exit 007



# helper function that return number of cores for a given node
getCoreCount() {
        RHOST=$1                        # there must be no space around the = sign
        # looks for processor line, but it includes hyperthread.  line is easy to parse, looks like this:
        # processors           48 
        # numprocs=`qconf -se $RHOST | \
        #                awk '/^processors/ {print $2}'`
        # looks for m_core inside the load_value section, which is intermingled with many other definitions, like:
        # this seems to exlude hyperthread count, and matches smp slots values
        # m_core=24,m_mem_free=96766.000000M, 
        numprocs=`qconf -se $RHOST | \
                        sed -e 's/,/\n/g' -e 's/\ /\n/g' | awk -F= '/m_core/ {print $2}'`
                        #sed 's/,/\n/g' | awk -F= '/m_core/ {print $2}'`
        return $numprocs
}


 
ME=`hostname`
#EXECHOSTS=`qconf -sel`
EXECHOSTS=`qconf -sel | grep compute`
#EXECHOSTS=`qconf -sel | grep compute-3-1`
 
for TARGETHOST in $EXECHOSTS; do
        if [ "$ME" == "$TARGETHOST" ]; then
                echo "Skipping $ME. This is the submission host"
        else
                getCoreCount $TARGETHOST 
                numprocs=$?
                if [ $numprocs -lt 1 ]; then
                        echo "skipping $TARGETHOST as numprocs ($numprocs) has unexpected value"
                else
                        # ideally exclusive COMPLEX if it has been added to  each and every host, then would be sure really no other job on node:
                        #echo qsub -p 1024 -pe mpi $numprocs -q default.q@$TARGETHOST --exclusive=true
                        qsub -p 1024 -pe smp $numprocs -q default.q@$TARGETHOST -l h_rt=600,m_mem_free=2G\
                                ./reboot.qsub
                        echo "Set $TARGETHOST for Reinstallation (numprocs=$numprocs)"

                fi
        fi
done
