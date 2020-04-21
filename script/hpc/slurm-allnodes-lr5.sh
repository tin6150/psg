#!/bin/sh 


####
#### helper script to run job on every node of a cluster, 
#### test slurm job scheduling/running abilities
#### and node abilities to run job
#### see bottom for submission command against all nodes using sbatch -w 
#### also for power/stress test.
####

#### slurm-allnodes-lr5.sh has the most notes as of 2020.04
#### slurm-job.sh, slurm-script-eg.sh are simple versions.
#### slurm-job-cf1.sh should have been clean version for a specific partition


#SBATCH				--job-name=allNodeTest    # CLI arg will overwrite this
#					CPU time:
#SBATCH				--time=605
#					Wall clock limit in HH:MM:ss
#	#SBATCH			--time=00:10:00
#   oh don't remember all the diff b/w -n -N --nodes=...   rtfm 
#   --nodes=2 --ntasks=8 --cpus-per-task=2 would span 2 nodes and give 4 tasks per node # https://research-it.berkeley.edu/services/high-performance-computing/running-your-jobs
#	#SBATCH			-n 3
#	#SBATCH			-N 3
#	#SBATCH			--ntasks=2
#	#SBATCH			--nodes=4
#	#SBATCH			--qos=cf_normal
#	#SBATCH  		--qos=lr_lowprio
#	#SBATCH  		--qos=lr_normal # cf_normal
#SBATCH				--qos=savio_normal 
#SBATCH				--account=scs

#SBATCH				--partition=savio3
#	#SBATCH			--partition=cf1

#### gpu gres request
#   #SBATCH         --partition=savio2_gpu
#   #SBATCH         --gres=gpu:2

## #SBATCH --constrain=savio2_1080ti   # feature in slurm.conf


#	#SBATCH			--mail-type=all
#	#SBATCH			--mail-type=END,FAIL
#   #SBATCH			--mail-type=FAIL
#SBATCH  			--mail-type=NONE
#SBATCH				--mail-user=tin@berkeley.edu
#	#SBATCH			--mail-user=tin@lbl.gov
#	#SBATCH			-o  slurm_testnode_%N_%j.txt
#	#SBATCH			-o  junkable_slurm_out_cf1.txt
#SBATCH				-o  sn_%N_%j.out

# %j is for jobid (eg 128)
# %J is for jobid.stepid (eg 128.0)
# %N is short node name
# %n is node number relative to current job, 0 for first node.  task spanning multiple node will get multiple file created
# -J is --job-name for CLI arg

### adapted from run_iozone_lr5.sh, but don't want to run iozone on prod fs.

################################################################################
##### print some header info into the log
################################################################################

LOGDIR=/global/scratch/tin/JUNK/
MAQ=$(hostname)
OUTFILE=$LOGDIR/$MAQ.out.rst
#hostname > $LOGDIR/$MAQ

# run whole thing in subshell to capture output to a file

(
echo ----hostname-----------------------------------
echo -n "hostname: " 
hostname 
echo ----date-----------------------------------
date

echo ---------------------------------------
echo ---------------------------------------
echo "----pwd; df -h /tmp -----------------------------------"
echo -n "pwd: "
pwd
df -h /tmp 
echo ----df-hl------------------------------
df -hl
echo -----proc-mounts----------------------------------
cat /proc/mounts

echo ----uname-r----------------------------------
echo -n "uname -r: " 
uname -r
echo ----os-release----------------------------------
cat /etc/os-release
echo ----uptime-----------------------------------
uptime



echo ----free-m----------------------------------
free -m
echo ----swapon-s-----------------------------------
swapon -s
echo ----lscpu-----------------------------------
lscpu
echo ----nuactl-s-----------------------------------
numactl -s
echo ---------------------------------------
echo ---------------------------------------

echo "==== 7z benchmark next ======================================================="
singularity exec /global/scratch/tin/singularity-repo/perf_tools_latest.sif /usr/bin/7za b

) > $OUTFILE

exit 0			#### comment out if want to run more test!                       ####

################################################################################
##### setup and run test in specific dir
################################################################################

##BASEDIR=/clusterfs/xmas/perf_test_tin/iozone3/
##BASEDIR=/global/scratch/tin/Junk/lr5/perf_test_tin/iozone3/
##BASEDIR=/global/scratch/tin/Junk/lr5/allNodeTest_tin/
BASEDIR=/global/scratch/tin/Junk/savio3/allNodeTest_tin/


HNAME=$(hostname)
DIR=$BASEDIR/scratch_$HNAME
[[ -d $DIR ]] || mkdir -p $DIR

cd $DIR

THREAD=1
# time now avail in slurm... it is not a binary... some shell thing??   not for lr5 (sl7)
#time -p ../iozone -i 0 -c -e -w -r 1024k -s  16g -t $THREAD -+n -b $DIR/result.xls
##../iozone -i 0 -c -e    -r 1024k -s 512m -t $THREAD -+n -b $DIR/result.xls	# 1x 512m file takes about 10s
# -w preserve test data, useful for read/rewrite test?...
# there is also ioperf?  io-perf?

## don't run iozone test on prod FS, so just do a light dd test
## maybe switch to run 1 node hpl in this space in future

time -p dd if=/dev/zero of=./dd.${HNAME}.out bs=1024 count=2 

################################################################################
##### adding some stuff to make job do a few things and gather some info
################################################################################

echo ---------------------------------------
echo ---------------------------------------
echo ----uptime-----------------------------------
uptime 
echo ----date-----------------------------------
date
echo "date before sleep"
date
sleep 180
echo "date after sleep"
date


exit 0

################################################################################
##### info on how to run
################################################################################

## example run 1: (from lrc-sl7):

## #sbatch  --partition=xmas --account=xmas  -w n0001.xmas0 /global/home/users/tin/sn-gh/psg/script/hpc/run_iozone_xmas0.sh

## example run 2:
#for T in $(seq -w 0010 0014); do
#        sbatch  --partition=xmas --account=xmas  -w n${T}.xmas0 /global/home/users/tin/sn-gh/psg/script/hpc/run_iozone_xmas0.sh
#done

## example run 3:
#for T in $(seq -w 0010 0014); do
#        sbatch  --partition=lr5 --account=scs  --qos=lr_normal -w n${T}.lr5 /global/home/users/tin/sn-gh/psg/script/hpc/run_iozone_lr5.sh
#done


## example run 4, from lrc-sl7:
# for T in $(seq -w 0000 0071); do
#        sbatch -w n${T}.cf1 --job-name=N${T}_cf1_allNodeTest /global/home/users/tin/sn-gh/psg/script/hpc/slurm-allnodes-lr5.sh
# done


## example run 4a:
#for T in $(seq -w 0139 0147); do
#for T in $(seq -w 0112 0135); do
#for T in $(seq -w 0006 0017); do
#        sbatch -w n${T}.savio3 --job-name=N${T}_allNodeTest /global/scratch/tin/tin-gh/psg/script/hpc/slurm-allnodes-lr5.sh
#                                                       # or /global/home/users/tin/sn-gh/psg/script/hpc/slurm-allnodes-lr5.sh
#done


#for T in $(seq -w 0279 0281); do
for T in $(seq -w 0236 0237); do
        sbatch -w n${T}.savio2 --job-name=N${T}_allNodeTest /global/scratch/tin/tin-gh/psg/script/hpc/slurm-allnodes-lr5.sh
done


## example submit to idle nodes only
## see slurm-allIdle-brc.sh  for more elaborate test?
NODELIST=$( sinfo --Node --long --format '%N %20P %.8t' | awk '/idle/ {print $1}' | tail -2 )
for NODE in $NODELIST; do
	echo sbatch -w ${NODE} --job-name=${NODE}_allNodeTest /global/scratch/tin/tin-gh/psg/script/hpc/slurm-allnodes-lr5.sh
done

