#!/bin/sh 


#SBATCH         	--job-name=lr5_liteIozone    # CLI arg will overwrite this
#               	CPU time:
#SBATCH         	--time=605
#      		      	Wall clock limit in HH:MM:ss
# 	#SBATCH       	--time=00:10:00
#SBATCH         	--partition=lr5
# 	#SBATCH       	-n 4
#SBATCH         	--qos=lr_normal
# 	#SBATCH       	--qos=lr_lowprio
#SBATCH         	--account=scs
# 	#SBATCH       	--ntasks=2
# 	#SBATCH       	--mail-type=all
# 	#SBATCH       	--mail-type=END,FAIL
#SBATCH         	--mail-type=FAIL
#SBATCH         	--mail-user=tin@lbl.gov
# 	#SBATCH       	-N 3
#SBATCH         	-o  slurm_iozonelite_%N_%j.txt
# 	#SBATCH       	-o  junkable_slurm_out_lr5.txt

# %j is for jobid (eg 128)
# %J is for jobid.stepid (eg 128.0)
# %N is short node name
# %n is node number relative to current job, 0 for first node.  task spanning multiple node will get multiple file created
# -J is --job-name for CLI arg

################################################################################
##### print some header info into the log
################################################################################

echo ----uptime-----------------------------------
uptime
echo ----date-----------------------------------
date
echo ---------------------------------------
echo ---------------------------------------


################################################################################
##### setup and run iozone, (tends to be lite test)
################################################################################

##BASEDIR=/clusterfs/xmas/perf_test_tin/iozone3/
BASEDIR=/global/scratch/tin/Junk/lr5/perf_test_tin/iozone3/

HNAME=$(hostname)
DIR=$BASEDIR/scratch_$HNAME
[[ -d $DIR ]] || mkdir $DIR

cd $DIR

#THREAD=1
THREAD=2
# time now avail in slurm... it is not a binary... some shell thing??   not for lr5 (sl7)
#time -p ../iozone -i 0 -c -e -w -r 1024k -s  16g -t $THREAD -+n -b $DIR/result.xls

../iozone -i 0 -c -e    -r 1024k -s 512m -t $THREAD -+n -b $DIR/result.xls	# 1x 512m file takes about 10s

# -w preserve test data, useful for read/rewrite test?...

# there is also ioperf?  io-perf?

################################################################################
##### adding some stuff to make job do a few things and gather some info
################################################################################

echo ---------------------------------------
echo ---------------------------------------
echo ----hostname-----------------------------------
echo -n "hostname: "
hostname
echo ----pwd-----------------------------------
echo -n "pwd: "
pwd
echo ----uname-r----------------------------------
echo -n "uname -r: " 
uname -r
echo ----os-release----------------------------------
cat /etc/os-release
echo ----df-hl------------------------------
df -hl
echo -----proc-mounts----------------------------------
cat /proc/mounts
echo ----uptime-----------------------------------
uptime

echo ---------------------------------------
echo ---------------------------------------
echo "date before sleep"
date
sleep 180
echo "date after sleep"
date



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



