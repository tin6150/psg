#!/bin/bash 

# script to run xHPL  (via Yong's staging.sh)
# expect to be running in a mostly empty dir, will create a dir to host output
# dir has sym link to parent dir where this script is :)


# undocumented env var for HPL to properly use AVX
#export HPL_HOST_ARCH=3 # AVX2
export HPL_HOST_ARCH=9 # AVX512


##RUNDIR=STAGING_OUT
RUNDIR=TMP_OUT
test -d $RUNDIR || mkdir $RUNDIR
cd $RUNDIR

BIOSOUT=/tmp/bios.settings.out
BIOSHIGHLIGHT=/tmp/bios.settings.highlight

cp -p $BIOSOUT .
cp -p $BIOSHIGHLIGHT .

#cat $BIOSOUT | egrep 'n0|MemOpMode|SubNumaCluster|SysProfile|ControlledTurbo|NodeInterleave|LogicalProc'
cat $BIOSHIGHLIGHT



#export PATH=$PATH:~tin/gsHPCS_toolkit/benchmark/hpl/hpl-2.2/bin/intel64_skylake_avx_optimiz/	# xhpl, no progress report :(
export PATH=$PATH:~tin/gsHPCS_toolkit/benchmark/hpl/hpl-2.2/bin/intel64_skylake/		# xhpl
##export PATH=$PATH:~tin/gsHPCS_toolkit/benchmark/hpl/hpl-2.2/bin/intel64_skylake_icc_2018
export PATH=$PATH:~tin/gsHPCS_toolkit/benchmark/staging_sl7					# mpi_nxnlatbw
export PATH=$PATH:/global/home/groups/scs/meli/					# osu_*
export PATH=$PATH:/global/home/groups/scs/yqin					# probably only for stream

test -d hpl || mkdir hpl
cp -p ~/gsHPCS_toolkit/benchmark/hpl/hpl_cf/32cores_96gb_90_nb192/HPL.MPI*dat hpl # 32 core for n000[4-7].testbed maybe future lr6
##cp -p ~/gsHPCS_toolkit/benchmark/hpl/hpl_cf/32cores_187gb_90_nb192/HPL.MPI*dat hpl # 2x RAM of 32 core for n000[4-7].testbed maybe future lr6
#cp -p ~/gsHPCS_toolkit/benchmark/hpl/hpl_cf/32cores_187gb_92_nb384/HPL.MPI*dat hpl # simulate dell benchmark 32 core for n000[4-7].testbed maybe future lr6

##cp -p ~/gsHPCS_toolkit/benchmark/hpl/hpl_cf/1to128cores/HPL.4x8.187gb_92.nb256.dat hpl
##cp -p ~/gsHPCS_toolkit/benchmark/hpl/hpl_cf/1to128cores/HPL.4x8.187gb_92.nb256.dat hpl/HPL.MPI.0001.dat
#cp -p ~/gsHPCS_toolkit/benchmark/hpl/hpl_cf/1to128cores/HPL.4x8.187gb_96.nb384.dat hpl
#cp -p ~/gsHPCS_toolkit/benchmark/hpl/hpl_cf/1to128cores/HPL.4x8.187gb_96.nb384.dat hpl/HPL.MPI.0001.dat # n0005 w/ borrowed RAM

#cp -p ~/gsHPCS_toolkit/benchmark/hpl/hpl_cf/1to128cores/HPL.4x8.93gb_96.nb384.dat hpl/
#cp -p ~/gsHPCS_toolkit/benchmark/hpl/hpl_cf/1to128cores/HPL.4x8.93gb_96.nb384.dat hpl/HPL.MPI.0001.dat # n0007.testbed

#cp -p ~/gsHPCS_toolkit/benchmark/hpl/hpl_cf/28cores_96gb_90_nb192/HPL.MPI*dat hpl   # 28 core for loaner n000[0-3].testbed
#cp -p ~/gsHPCS_toolkit/benchmark/hpl/hpl_cf/28cores_96gb_90_nb192/HPL.MPI*dat hpl   # 28 core for loaner n000[0-3].testbed

#for N in $(seq -w 02 02); do
#for N in $(seq -w 06 07); do
#	echo n00$N.testbed 
#done > nodelist

echo "n0005.testbed n0006.testbed n0007.testbed" | sed 's/ /\n/g' > nodelist



## mpi problem of 2018.0220 works with IP but not hostname.  reports unfortunately stripped partition and mislead to a "dot" parsing issue.
#echo "n0000.testbed n0001.testbed n0003.testbed" | sed 's/ /\n/g' > nodelist
#echo "10.0.199.1 10.0.199.3 10.0.199.6" | sed 's/ /\n/g' > nodelist
#echo "n0001_testbed n0001_testbed n0001_testbed" | sed 's/ /\n/g' > nodelist

# tmp for single node test
#hostname > nodelist

module purge
#module load gcc openmpi
module load intel openmpi
# new intel compiler and lib in personal SMF for now
#module load langs/intel/2018.1.163_eval 
#module load intel/2018.1.163/mkl/2018.1.163_eval
#module load intel/2018.1.163/openmpi/2.0.4-intel_eval
module list

numactl -H > numactl-H.out
ompi_info -a > ompi_info-a.out

cp -p ../../racadmSetBios.sh .


# /global/home/groups/scs/yqin/staging.sh  -t osu_bw 
# ~/gsHPCS_toolkit/benchmark/staging_sl7/staging.sh -t osu_bw
# ~/gsHPCS_toolkit/benchmark/staging_sl7/staging.sh -ps			# s = sanity test
# mpi_nxnlatbw osu_bcast osu_bw osu_bibw osu_latency osu_mbw_mr osu_multi_lat osu_alltoall
# ~/gsHPCS_toolkit/benchmark/staging_sl7/staging.sh -pa			# a = all tests

which staging.sh
which xhpl

date > HPL.starttime
#~/gsHPCS_toolkit/benchmark/staging_sl7/staging.sh -t hpl
~/gsHPCS_toolkit/benchmark/staging_sl7/staging.sh -pa	

#cp -p hpl/HPL.MPI.0001.dat ./HPL.dat
#mpirun -np 32 -npernode 32 -bind-to core --report-bindings -mca btl sm,self xhpl 2>&1|tee mpi-HPL.log
#mpirun -np 3 -npernode 1 -bind-to core --report-bindings -mca btl sm,self --hostfile ./nodelist hostname 2>&1|tee mpi-HPL.log
date > HPL.endtime

#  staging.sh  -h 			# help, list all avail test
#  staging.sh  -t osu_bw -d
# -d is for dry run, which essentially read results from previous run and just print them again.


## cd ~/gsCF_BK/testbed/staging_test/STAGING_OUT_HTon/hpl
## mpirun -np 64 xhpl | tee hpl.out
