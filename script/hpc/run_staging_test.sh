#!/bin/bash 


#### 
####  MOVED to ~/HPCS_toolkit
#### 


# this version is from cf1/run_staging_test_sanity.sh   # vs _hpl version
# prev version is from testbed/run_staging_test.sh
# there are ver in lr5, maybe other.  

# script to run Yong's staging.sh
# expect to be running in a mostly empty dir, will create a dir to host output
# dir has sym link to parent dir where this script is :)
# lately picking a node last in the nodelist file to run this script, as user (not root)

# trimmed down version of run_staging_test_hpl.sh now

# undocumented env var for HPL to properly use AVX
# Josh said they don't do anything
#export HPL_HOST_ARCH=3 # AVX2
#export HPL_HOST_ARCH=9 # AVX512
# KNL has AVX512, may need to dig into these as well...


FECHA=$(date +%m%d_%H%M)
RUNDIR=STAGING_OUT/STAGING_OUT_${FECHA}
##RUNDIR=OUT_Sanity				# for connectivity test
test -d $RUNDIR || mkdir -p $RUNDIR
cp -p nodelist $RUNDIR
cd $RUNDIR


#export PATH=$PATH:~tin/gsHPCS_toolkit/benchmark/hpl/hpl-2.2/bin/intel64_skylake_avx_optimiz/	# xhpl, no progress report :(
#export PATH=$PATH:~tin/gsHPCS_toolkit/benchmark/hpl/hpl-2.2/bin/intel64_skylake/		# xhpl

## need new binary...  or use intel's binary??
#export PATH=~tin/gsHPCS_toolkit/benchmark/hpl/hpl-2.2/bin/intel64_skylake_icc_2018:$PATH   

#export PATH=~tin/gsHPCS_toolkit/benchmark/hpl/hpl-2.2/bin/intel64_phi_7210/:$PATH	# intel 2016 compiler stack
export PATH=~tin/gsHPCS_toolkit/benchmark/hpl/hpl-2.2/bin/intel2018_phi_7210:$PATH	# intel 2018 compiler stack
##export PATH=~tin/HPCS_toolkit/benchmark/hpl/hpl-2.2/bin/intel2018_phi_7210:$PATH	# intel 2018 compiler stack

#export PATH=~tin/gsHPCS_toolkit/benchmark/hpl/hpl-2.2/bin/intel64_nehalem:$PATH	# intel 2016 compiler stack, last tested to work for MeLi 2018.0627
#export PATH=~tin/gsHPCS_toolkit/benchmark/hpl/hpl-2.2/bin/intel64_broadwell:$PATH		# intel 2016 compiler stack , use progress number due to timing bug.  similar result than nehalem bin.

export PATH=$PATH:~tin/gsHPCS_toolkit/benchmark/staging_sl7					# mpi_nxnlatbw
export PATH=$PATH:/global/home/groups/scs/meli/					# osu_*
export PATH=$PATH:/global/home/groups/scs/yqin					# probably only for stream

test -d hpl || mkdir hpl

#### FIXME need a 20core for lr5a...
#cp -p  ~/gsHPCS_toolkit/benchmark/hpl/hpl_cf/64core_192gb_90_nb192/HPL.MPI*dat hpl   # 64 core knl 
cp -p  ~/gsHPCS_toolkit/benchmark/hpl/hpl_cf/20cores_128gb_90_nb192/HPL.MPI*dat hpl   # 20 cores Penguin LR5a
#cp -p  ~/gsHPCS_toolkit/benchmark/hpl/hpl_cf/1to128cores/HPL.MPI*dat hpl   # brief test, don't have expected filename, not useful
#cp -p  ~/gsHPCS_toolkit/benchmark/hpl/hpl_cf/64core_192gb_90_nb192/HPL.MPI*dat hpl/HPL.MPI.0001.dat 


#for N in $(seq 0 13); do
#	echo 10.0.39.$N
#done > nodelist
#for N in $(seq 15 19); do
#	echo 10.0.39.$N
#done >> nodelist


# tmp for single node test		## *** 007 *** :)
#hostname > nodelist

module purge
#module load gcc openmpi
module load intel/2016.4.072 openmpi/2.0.2-intel mkl/2016.4.072
##module load intel mkl openmpi
# new intel compiler and lib in personal SMF for now (these worked on testbed, but no IB)
# hmm.... still don't work for knl expansion...
#module load langs/intel/2018.1.163_eval 
#module load intel/2018.1.163/mkl/2018.1.163_eval
#module load intel/2018.1.163/openmpi/2.0.4-intel_eval
##--don't seesm to work for osu benchmark, but should work for hpl :
## nope, orte can't start...
##module load intel/2018.1.163 mkl/2018.1.163 openmpi/2.0.2-intel
module list

ompi_info -a > ompi_info-a.out

which staging.sh
which xhpl


#~/gsHPCS_toolkit/benchmark/staging_sl7/staging.sh -h 			# help, list all avail test
# /global/home/groups/scs/yqin/staging.sh  -t osu_bw 
# ~/gsHPCS_toolkit/benchmark/staging_sl7/staging.sh -ps			# s = sanity test

# mpi_nxnlatbw osu_bcast osu_bw osu_bibw osu_latency osu_mbw_mr osu_multi_lat osu_alltoall
#~/gsHPCS_toolkit/benchmark/staging_sl7/staging.sh -pa			# a = all tests
##~/gsHPCS_toolkit/benchmark/staging_sl7/staging.sh -t osu_multi_lat	# this is hanging...

#TEST_LIST="cpuinfo meminfo partitions uptime ibstatus dmesg hostname ifconfig ldconfig lspci lsmod ps release rpm top check_mounts check_owner_perms df stream mpi_nxnlatbw osu_bcast osu_bw osu_bibw osu_latency osu_mbw_mr osu_multi_lat osu_alltoall hpl"
TEST_LIST="cpuinfo meminfo partitions uptime ibstatus dmesg hostname ifconfig ldconfig lspci lsmod ps release rpm top check_mounts check_owner_perms df stream mpi_nxnlatbw osu_bcast osu_bw osu_bibw osu_latency osu_mbw_mr osu_multi_lat osu_alltoall" ### no hpl
#TEST_LIST="cpuinfo meminfo partitions uptime ibstatus dmesg hostname ifconfig ldconfig lspci lsmod ps release rpm top check_mounts check_owner_perms df stream mpi_nxnlatbw osu_bcast osu_bw osu_bibw osu_latency osu_mbw_mr osu_alltoall hpl" ### no osu_multi_lat

##TEST_LIST="osu_alltoall mpi_nxnlatbw osu_multi_lat"
#TEST_LIST="osu_multi_lat"	# best use power of 2 number of nodes, def break in odd num of nodes.
#TEST_LIST="osu_alltoall"
#TEST_LIST="hpl"

for TST in $TEST_LIST; do
	#~/gsHPCS_toolkit/benchmark/staging_sl7/staging.sh -t $TST
	~/gsHPCS_toolkit/benchmark/staging_sl7/staging.sh -pa
done


##~/gsHPCS_toolkit/benchmark/staging_sl7/staging.sh -t hpl			### <<< RUN HPL <<<


#  staging.sh  -t osu_bw -d
# -d is for dry run, which essentially read results from previous run and just print them again.

